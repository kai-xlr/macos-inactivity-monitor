# macOS Inactivity Monitor

A background macOS utility that detects applications that have been open and inactive for a configurable period, prompting the user to close or force quit them to reclaim system resources.

## Features

- **Automatic Inactivity Detection** - Tracks app activation events to determine when apps have been idle
- **Configurable Threshold** - Set custom inactivity timeout (default: 30 minutes)
- **Interactive Alerts** - Three options per alert: Close App, Force Quit, or Ignore
- **Allowlist System** - Exclude specific apps from monitoring with persistent UserDefaults storage
- **Menu Bar Integration** - Quick access to monitoring toggle from the system menu bar
- **SwiftUI Dashboard** - Clean interface with Dashboard, Allowlist, and Settings tabs

## Requirements

- macOS 12.0 (Monterey) or later
- Xcode 14.0 or later (for building)

## Building

Generate the Xcode project and build:

```bash
xcodegen generate
xcodebuild -project InactivityMonitor.xcodeproj -scheme InactivityMonitor -configuration Debug build
```

Or open `InactivityMonitor.xcodeproj` directly in Xcode.

## Running

After building, the app will be in:
```
~/Library/Developer/Xcode/DerivedData/InactivityMonitor-*/Build/Products/Debug/InactivityMonitor.app
```

Or run from Xcode with ⌘R.

## Usage

1. Launch the app - the main window shows the Dashboard
2. Click "Start Monitoring" in the menu bar (or toggle via Settings tab)
3. Apps left inactive past the threshold will trigger alerts
4. Choose to Close, Force Quit, or Ignore each app
5. Add apps to the Allowlist tab to exclude them from monitoring

## Architecture

```
Sources/
├── main.swift              # App entry point
├── AppDelegate.swift       # Window and menu bar setup
├── ContentView.swift       # Tab container view
├── Core/
│   ├── MonitorEngine.swift # NSWorkspace notification handling
│   └── ActivityTracker.swift
├── Models/
│   ├── AppInfo.swift       # Running app data model
│   └── SettingsManager.swift
├── Services/
│   ├── AllowlistService.swift
│   ├── ProcessService.swift # App termination
│   └── AlertService.swift
└── UI/
    ├── DashboardView.swift
    ├── SettingsView.swift
    └── AllowlistView.swift
```

## Tech Stack

- Swift 5.9
- SwiftUI
- AppKit (NSWorkspace for app lifecycle events)

## License

MIT
