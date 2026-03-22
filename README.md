# macOS Inactivity Monitor

A background macOS utility that detects applications open and inactive for a configurable period, prompting the user to close or force quit them.

## Features

- Detect inactive applications automatically
- Configurable inactivity threshold (default: 30 minutes)
- Popup alerts with actions: Close, Force Quit, or Ignore
- Allowlist system for apps to exclude
- GUI dashboard for monitoring
- Menu bar support

## Requirements

- macOS 12.0+
- Xcode 14.0+

## Building

```bash
cd InactivityMonitor
xcodegen generate
xcodebuild -project InactivityMonitor.xcodeproj -scheme InactivityMonitor -configuration Debug build
```

Or open `InactivityMonitor/InactivityMonitor.xcodeproj` in Xcode.

## Tech Stack

- Swift 5.9
- SwiftUI
- AppKit (NSWorkspace, Accessibility APIs)

## License

MIT
