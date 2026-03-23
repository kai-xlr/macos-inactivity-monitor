import Foundation
import AppKit

class MonitorEngine: ObservableObject {
    static let shared = MonitorEngine()
    
    @Published var runningApps: [AppInfo] = []
    @Published var isMonitoring: Bool = false
    
    private var monitorTimer: Timer?
    private let activityTracker = ActivityTracker.shared
    private let allowlistService = AllowlistService.shared
    private let alertService = AlertService.shared
    
    private var workspaceObservers: [NSObjectProtocol] = []
    
    private init() {}
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        
        refreshRunningApps()
        setupWorkspaceObservers()
        startMonitorTimer()
        
        NotificationCenter.default.post(name: .monitoringStateChanged, object: nil)
    }
    
    func stopMonitoring() {
        guard isMonitoring else { return }
        
        isMonitoring = false
        
        monitorTimer?.invalidate()
        monitorTimer = nil
        
        removeWorkspaceObservers()
        
        NotificationCenter.default.post(name: .monitoringStateChanged, object: nil)
    }
    
    func refreshRunningApps() {
        let workspace = NSWorkspace.shared
        let activeApps = workspace.runningApplications
        
        var updatedApps: [AppInfo] = []
        
        for app in activeApps {
            guard let bundleID = app.bundleIdentifier,
                  !bundleID.hasPrefix("com.apple."),
                  app.activationPolicy == .regular else {
                continue
            }
            
            let name = app.localizedName ?? bundleID
            
            if let existingApp = runningApps.first(where: { $0.bundleID == bundleID }) {
                var appInfo = existingApp
                appInfo.processIdentifier = app.processIdentifier
                appInfo.isAllowlisted = allowlistService.isAllowlisted(bundleID: bundleID)
                updatedApps.append(appInfo)
            } else {
                var appInfo = AppInfo(
                    bundleID: bundleID,
                    name: name,
                    launchTime: app.launchDate ?? Date(),
                    processIdentifier: app.processIdentifier
                )
                appInfo.isAllowlisted = allowlistService.isAllowlisted(bundleID: bundleID)
                updatedApps.append(appInfo)
            }
        }
        
        DispatchQueue.main.async {
            self.runningApps = updatedApps.sorted { $0.name < $1.name }
        }
    }
    
    func getRunningApps() -> [AppInfo] {
        return runningApps
    }
    
    private func setupWorkspaceObservers() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        
        let activationObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleAppActivated(notification)
        }
        
        let launchObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didLaunchApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleAppLaunched(notification)
        }
        
        let terminateObserver = notificationCenter.addObserver(
            forName: NSWorkspace.didTerminateApplicationNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleAppTerminated(notification)
        }
        
        workspaceObservers = [activationObserver, launchObserver, terminateObserver]
    }
    
    private func removeWorkspaceObservers() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        for observer in workspaceObservers {
            notificationCenter.removeObserver(observer)
        }
        workspaceObservers.removeAll()
    }
    
    private func handleAppActivated(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              let bundleID = app.bundleIdentifier else {
            return
        }
        
        activityTracker.handleAppActivated(bundleID: bundleID)
        
        if let index = runningApps.firstIndex(where: { $0.bundleID == bundleID }) {
            runningApps[index].lastActiveTime = Date()
        }
    }
    
    private func handleAppLaunched(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              let bundleID = app.bundleIdentifier,
              app.activationPolicy == .regular else {
            return
        }
        
        let name = app.localizedName ?? bundleID
        var appInfo = AppInfo(
            bundleID: bundleID,
            name: name,
            launchTime: app.launchDate ?? Date(),
            processIdentifier: app.processIdentifier
        )
        appInfo.isAllowlisted = allowlistService.isAllowlisted(bundleID: bundleID)
        
        if !runningApps.contains(where: { $0.bundleID == bundleID }) {
            DispatchQueue.main.async {
                self.runningApps.append(appInfo)
                self.runningApps.sort { $0.name < $1.name }
            }
        }
    }
    
    private func handleAppTerminated(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              let bundleID = app.bundleIdentifier else {
            return
        }
        
        DispatchQueue.main.async {
            self.runningApps.removeAll { $0.bundleID == bundleID }
        }
    }
    
    private func startMonitorTimer() {
        monitorTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.evaluateInactivity()
            self?.objectWillChange.send()
        }
        
        RunLoop.main.add(monitorTimer!, forMode: .common)
    }
    
    private func evaluateInactivity() {
        guard SettingsManager.shared.monitoringEnabled else { return }
        
        let now = Date()
        let thresholdSeconds = Double(SettingsManager.shared.inactivityThreshold * 60)
        
        for app in runningApps {
            guard !app.isAllowlisted else { continue }
            
            let inactiveDuration = now.timeIntervalSince(app.lastActiveTime)
            
            if inactiveDuration >= thresholdSeconds {
                if !alertService.hasPendingAlert(for: app.bundleID) {
                    alertService.showAlert(for: app) { [weak self] action in
                        self?.handleAlertAction(action, for: app)
                    }
                }
            }
        }
    }
    
    private func handleAlertAction(_ action: AlertAction, for app: AppInfo) {
        switch action {
        case .closeApp:
            ProcessService.shared.terminate(app: app)
        case .forceQuit:
            ProcessService.shared.forceTerminate(app: app)
        case .ignore:
            allowlistService.addApp(bundleID: app.bundleID)
            if let index = runningApps.firstIndex(where: { $0.bundleID == app.bundleID }) {
                runningApps[index].isAllowlisted = true
            }
        case .dismiss:
            break
        }
    }
    
    func updateAllowlistStatus() {
        for i in 0..<runningApps.count {
            runningApps[i].isAllowlisted = allowlistService.isAllowlisted(bundleID: runningApps[i].bundleID)
        }
    }
}

extension Notification.Name {
    static let monitoringStateChanged = Notification.Name("monitoringStateChanged")
    static let appsUpdated = Notification.Name("appsUpdated")
}
