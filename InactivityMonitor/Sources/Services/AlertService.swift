import Foundation
import AppKit

enum AlertAction {
    case closeApp
    case forceQuit
    case ignore
    case dismiss
}

class AlertService {
    static let shared = AlertService()
    
    private var pendingAlerts: Set<String> = []
    private let lock = NSLock()
    
    private init() {}
    
    func hasPendingAlert(for bundleID: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return pendingAlerts.contains(bundleID)
    }
    
    func showAlert(for app: AppInfo, completion: @escaping (AlertAction) -> Void) {
        lock.lock()
        if pendingAlerts.contains(app.bundleID) {
            lock.unlock()
            return
        }
        pendingAlerts.insert(app.bundleID)
        lock.unlock()
        
        DispatchQueue.main.async {
            self.displayAlert(for: app, completion: completion)
        }
    }
    
    private func displayAlert(for app: AppInfo, completion: @escaping (AlertAction) -> Void) {
        let alert = NSAlert()
        alert.messageText = "App Inactivity Detected"
        
        let threshold = SettingsManager.shared.inactivityThreshold
        alert.informativeText = "\(app.name) has been inactive for \(threshold) minutes.\n\nWould you like to close it?"
        
        alert.alertStyle = .warning
        
        alert.addButton(withTitle: "Close App")
        alert.addButton(withTitle: "Force Quit")
        alert.addButton(withTitle: "Ignore")
        alert.addButton(withTitle: "Dismiss")
        
        alert.window.center()
        
        let response = alert.runModal()
        
        lock.lock()
        pendingAlerts.remove(app.bundleID)
        lock.unlock()
        
        switch response {
        case .alertFirstButtonReturn:
            completion(.closeApp)
        case .alertSecondButtonReturn:
            completion(.forceQuit)
        case .alertThirdButtonReturn:
            completion(.ignore)
        default:
            completion(.dismiss)
        }
    }
    
    func clearPendingAlert(for bundleID: String) {
        lock.lock()
        pendingAlerts.remove(bundleID)
        lock.unlock()
    }
    
    func clearAllPendingAlerts() {
        lock.lock()
        pendingAlerts.removeAll()
        lock.unlock()
    }
}
