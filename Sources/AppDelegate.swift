import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMainWindow()
        setupMenuBar()
        
        if SettingsManager.shared.monitoringEnabled {
            MonitorEngine.shared.startMonitoring()
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        MonitorEngine.shared.stopMonitoring()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    private func setupMainWindow() {
        let contentView = ContentView()
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window?.title = "Inactivity Monitor"
        window?.center()
        window?.setFrameAutosaveName("MainWindow")
        window?.contentView = NSHostingView(rootView: contentView)
        window?.makeKeyAndOrderFront(nil)
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "app.badge.clock", accessibilityDescription: "Inactivity Monitor")
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Open Inactivity Monitor", action: #selector(openMainWindow), keyEquivalent: "o"))
        
        menu.addItem(NSMenuItem.separator())
        
        let monitoringItem = NSMenuItem(title: "Start Monitoring", action: #selector(toggleMonitoring), keyEquivalent: "m")
        monitoringItem.state = SettingsManager.shared.monitoringEnabled ? .on : .off
        menu.addItem(monitoringItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func openMainWindow() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func toggleMonitoring() {
        let settings = SettingsManager.shared
        
        if settings.monitoringEnabled {
            MonitorEngine.shared.stopMonitoring()
        } else {
            MonitorEngine.shared.startMonitoring()
        }
        
        if let menu = statusItem?.menu,
           let item = menu.items.first(where: { $0.action == #selector(toggleMonitoring) }) {
            item.state = settings.monitoringEnabled ? .on : .off
            item.title = settings.monitoringEnabled ? "Stop Monitoring" : "Start Monitoring"
        }
    }
}
