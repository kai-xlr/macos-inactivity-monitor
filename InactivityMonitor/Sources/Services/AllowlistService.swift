import Foundation

class AllowlistService {
    static let shared = AllowlistService()
    
    private let settingsManager = SettingsManager.shared
    
    private init() {}
    
    func addApp(bundleID: String) {
        settingsManager.addToAllowlist(bundleID: bundleID)
        MonitorEngine.shared.updateAllowlistStatus()
        NotificationCenter.default.post(name: .allowlistUpdated, object: nil)
    }
    
    func removeApp(bundleID: String) {
        settingsManager.removeFromAllowlist(bundleID: bundleID)
        MonitorEngine.shared.updateAllowlistStatus()
        NotificationCenter.default.post(name: .allowlistUpdated, object: nil)
    }
    
    func isAllowlisted(bundleID: String) -> Bool {
        return settingsManager.isAllowlisted(bundleID: bundleID)
    }
    
    func getAllowlist() -> Set<String> {
        return settingsManager.allowlistBundleIDs
    }
}

extension Notification.Name {
    static let allowlistUpdated = Notification.Name("allowlistUpdated")
}
