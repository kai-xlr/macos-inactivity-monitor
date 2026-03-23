import Foundation
import AppKit

class ProcessService {
    static let shared = ProcessService()
    
    private init() {}
    
    func terminate(app: AppInfo) {
        guard let runningApp = NSRunningApplication(processIdentifier: app.processIdentifier) else {
            return
        }
        
        runningApp.terminate()
    }
    
    func forceTerminate(app: AppInfo) {
        guard let runningApp = NSRunningApplication(processIdentifier: app.processIdentifier) else {
            return
        }
        
        runningApp.forceTerminate()
    }
    
    func terminate(bundleID: String) {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications
        
        for app in runningApps {
            if app.bundleIdentifier == bundleID {
                app.terminate()
                return
            }
        }
    }
    
    func forceTerminate(bundleID: String) {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications
        
        for app in runningApps {
            if app.bundleIdentifier == bundleID {
                app.forceTerminate()
                return
            }
        }
    }
}
