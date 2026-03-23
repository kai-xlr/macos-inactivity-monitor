import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsManager = SettingsManager.shared
    @ObservedObject var monitorEngine = MonitorEngine.shared
    
    var body: some View {
        Form {
            Section {
                Toggle("Enable Monitoring", isOn: $settingsManager.monitoringEnabled)
                    .onChange(of: settingsManager.monitoringEnabled) { newValue in
                        if newValue {
                            monitorEngine.startMonitoring()
                        } else {
                            monitorEngine.stopMonitoring()
                        }
                    }
            } header: {
                Text("Monitoring")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Inactivity Threshold")
                        Spacer()
                        Text("\(settingsManager.inactivityThreshold) minutes")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(settingsManager.inactivityThreshold) },
                            set: { settingsManager.inactivityThreshold = Int($0) }
                        ),
                        in: 5...120,
                        step: 5
                    )
                }
            } header: {
                Text("Timeout")
            } footer: {
                Text("Apps will be considered inactive after this duration of no user interaction.")
            }
            
            Section {
                Toggle("Show Menu Bar Icon", isOn: $settingsManager.showMenuBarIcon)
            } header: {
                Text("Appearance")
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 250)
    }
}
