import SwiftUI

struct AllowlistView: View {
    @State private var allowlist: Set<String> = SettingsManager.shared.allowlistBundleIDs
    @State private var showAddSheet = false
    @State private var newBundleID = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Allowlisted Applications")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showAddSheet = true
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
                .help("Add application to allowlist")
            }
            .padding()
            
            Divider()
            
            if allowlist.isEmpty {
                VStack {
                    Spacer()
                    Text("No allowlisted applications")
                        .foregroundColor(.secondary)
                    Text("Add apps to exclude them from inactivity monitoring")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                List {
                    ForEach(Array(allowlist).sorted(), id: \.self) { bundleID in
                        HStack {
                            if let name = getAppName(for: bundleID) {
                                Text(name)
                                    .font(.system(size: 13))
                                Spacer()
                            }
                            Text(bundleID)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .contextMenu {
                            Button("Remove from Allowlist", role: .destructive) {
                                removeFromAllowlist(bundleID: bundleID)
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
            
            Divider()
            
            HStack {
                Text("\(allowlist.count) apps in allowlist")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            refreshAllowlist()
        }
        .sheet(isPresented: $showAddSheet) {
            AddAllowlistSheet(
                isPresented: $showAddSheet,
                bundleID: $newBundleID,
                onAdd: addToAllowlist
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: .allowlistUpdated)) { _ in
            refreshAllowlist()
        }
    }
    
    private func refreshAllowlist() {
        allowlist = SettingsManager.shared.allowlistBundleIDs
    }
    
    private func getAppName(for bundleID: String) -> String? {
        let workspace = NSWorkspace.shared
        if let url = workspace.urlForApplication(withBundleIdentifier: bundleID) {
            return FileManager.default.displayName(atPath: url.path)
        }
        return nil
    }
    
    private func addToAllowlist() {
        guard !newBundleID.isEmpty else { return }
        AllowlistService.shared.addApp(bundleID: newBundleID)
        newBundleID = ""
        refreshAllowlist()
    }
    
    private func removeFromAllowlist(bundleID: String) {
        AllowlistService.shared.removeApp(bundleID: bundleID)
        refreshAllowlist()
    }
}

struct AddAllowlistSheet: View {
    @Binding var isPresented: Bool
    @Binding var bundleID: String
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add to Allowlist")
                .font(.headline)
            
            TextField("Bundle ID (e.g., com.apple.Safari)", text: $bundleID)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            
            HStack {
                Button("Cancel") {
                    bundleID = ""
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Add") {
                    onAdd()
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
                .disabled(bundleID.isEmpty)
            }
        }
        .padding()
        .frame(width: 350)
    }
}
