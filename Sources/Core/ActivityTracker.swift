import Foundation

class ActivityTracker {
    static let shared = ActivityTracker()
    
    private var activityTimestamps: [String: Date] = [:]
    private let lock = NSLock()
    
    private init() {}
    
    func handleAppActivated(bundleID: String) {
        lock.lock()
        defer { lock.unlock() }
        
        activityTimestamps[bundleID] = Date()
    }
    
    func updateLastActiveTime(bundleID: String) {
        lock.lock()
        defer { lock.unlock() }
        
        activityTimestamps[bundleID] = Date()
    }
    
    func getLastActiveTime(for bundleID: String) -> Date? {
        lock.lock()
        defer { lock.unlock() }
        
        return activityTimestamps[bundleID]
    }
    
    func removeActivity(for bundleID: String) {
        lock.lock()
        defer { lock.unlock() }
        
        activityTimestamps.removeValue(forKey: bundleID)
    }
    
    func clearAll() {
        lock.lock()
        defer { lock.unlock() }
        
        activityTimestamps.removeAll()
    }
}
