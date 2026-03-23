import Foundation

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let inactivityThreshold = "inactivityThreshold"
        static let monitoringEnabled = "monitoringEnabled"
        static let allowlistBundleIDs = "allowlistBundleIDs"
        static let showMenuBarIcon = "showMenuBarIcon"
    }
    
    @Published var inactivityThreshold: Int {
        didSet {
            defaults.set(inactivityThreshold, forKey: Keys.inactivityThreshold)
        }
    }
    
    @Published var monitoringEnabled: Bool {
        didSet {
            defaults.set(monitoringEnabled, forKey: Keys.monitoringEnabled)
        }
    }
    
    @Published var showMenuBarIcon: Bool {
        didSet {
            defaults.set(showMenuBarIcon, forKey: Keys.showMenuBarIcon)
        }
    }
    
    var allowlistBundleIDs: Set<String> {
        get {
            let array = defaults.stringArray(forKey: Keys.allowlistBundleIDs) ?? []
            return Set(array)
        }
        set {
            defaults.set(Array(newValue), forKey: Keys.allowlistBundleIDs)
        }
    }
    
    private init() {
        self.inactivityThreshold = defaults.object(forKey: Keys.inactivityThreshold) as? Int ?? 30
        self.monitoringEnabled = defaults.object(forKey: Keys.monitoringEnabled) as? Bool ?? true
        self.showMenuBarIcon = defaults.object(forKey: Keys.showMenuBarIcon) as? Bool ?? true
    }
    
    func addToAllowlist(bundleID: String) {
        var current = allowlistBundleIDs
        current.insert(bundleID)
        allowlistBundleIDs = current
    }
    
    func removeFromAllowlist(bundleID: String) {
        var current = allowlistBundleIDs
        current.remove(bundleID)
        allowlistBundleIDs = current
    }
    
    func isAllowlisted(bundleID: String) -> Bool {
        return allowlistBundleIDs.contains(bundleID)
    }
}
