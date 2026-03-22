import SwiftUI
import AppKit

struct DashboardView: View {
    @ObservedObject var monitorEngine = MonitorEngine.shared
    @State private var selectedApp: AppInfo?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Running Applications")
                    .font(.headline)
                Spacer()
                Button(action: {
                    monitorEngine.refreshRunningApps()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .buttonStyle(.borderless)
                .help("Refresh app list")
            }
            .padding()
            
            Divider()
            
            if monitorEngine.runningApps.isEmpty {
                VStack {
                    Spacer()
                    Text("No applications to monitor")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                List(selection: $selectedApp) {
                    ForEach(monitorEngine.runningApps) { app in
                        AppRowView(app: app)
                            .tag(app)
                            .contextMenu {
                                Button("Close App") {
                                    ProcessService.shared.terminate(app: app)
                                }
                                Button("Force Quit") {
                                    ProcessService.shared.forceTerminate(app: app)
                                }
                                Divider()
                                if app.isAllowlisted {
                                    Button("Remove from Allowlist") {
                                        AllowlistService.shared.removeApp(bundleID: app.bundleID)
                                    }
                                } else {
                                    Button("Add to Allowlist") {
                                        AllowlistService.shared.addApp(bundleID: app.bundleID)
                                    }
                                }
                            }
                    }
                }
                .listStyle(.inset)
            }
            
            Divider()
            
            HStack {
                Text("\(monitorEngine.runningApps.count) apps")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(monitorEngine.isMonitoring ? "Monitoring" : "Paused")
                    .font(.caption)
                    .foregroundColor(monitorEngine.isMonitoring ? .green : .orange)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

struct AppRowView: View {
    let app: AppInfo
    
    var body: some View {
        HStack(spacing: 12) {
            getAppIcon(for: app)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(app.name)
                        .font(.system(size: 13, weight: .medium))
                    
                    if app.isAllowlisted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
                
                HStack(spacing: 8) {
                    Text(app.isInactive ? "Inactive" : "Active")
                        .font(.caption)
                        .foregroundColor(app.isInactive ? .orange : .green)
                    
                    if app.isInactive {
                        Text(app.formattedInactivityDuration)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("Last active")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(timeAgo(from: app.lastActiveTime))
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func getAppIcon(for app: AppInfo) -> Image {
        let workspace = NSWorkspace.shared
        if let path = workspace.urlForApplication(withBundleIdentifier: app.bundleID)?.path {
            return Image(nsImage: NSWorkspace.shared.icon(forFile: path))
        }
        return Image(systemName: "app.fill")
    }
    
    private func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        
        if minutes < 1 {
            return "Just now"
        } else if minutes < 60 {
            return "\(minutes)m ago"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours)h \(remainingMinutes)m ago"
        }
    }
}
