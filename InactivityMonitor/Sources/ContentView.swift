import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "list.bullet.rectangle")
                }
                .tag(0)
            
            AllowlistView()
                .tabItem {
                    Label("Allowlist", systemImage: "checkmark.circle")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}
