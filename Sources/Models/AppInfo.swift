import Foundation
import AppKit

struct AppInfo: Identifiable, Equatable, Hashable {
    let id: String
    let bundleID: String
    let name: String
    let launchTime: Date
    var lastActiveTime: Date
    var isAllowlisted: Bool
    var processIdentifier: pid_t
    
    init(bundleID: String, name: String, launchTime: Date, processIdentifier: pid_t) {
        self.id = bundleID
        self.bundleID = bundleID
        self.name = name
        self.launchTime = launchTime
        self.lastActiveTime = launchTime
        self.isAllowlisted = false
        self.processIdentifier = processIdentifier
    }
    
    var isInactive: Bool {
        return Date().timeIntervalSince(lastActiveTime) > Double(SettingsManager.shared.inactivityThreshold) * 60
    }
    
    var inactivityDuration: TimeInterval {
        return Date().timeIntervalSince(lastActiveTime)
    }
    
    var formattedInactivityDuration: String {
        let minutes = Int(inactivityDuration / 60)
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)m"
        }
    }
    
    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        return lhs.bundleID == rhs.bundleID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(bundleID)
    }
}
