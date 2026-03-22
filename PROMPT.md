# Task

Build a macOS application in Swift that runs in the background and monitors application inactivity.

## Requirements

- Track running applications using NSWorkspace
- Detect when an app has been inactive for 30 minutes
- Inactivity definition:
  - App not frontmost for 30 minutes
- Show alert with:
  - Close app
  - Force quit
  - Ignore

## Features

- Allowlist system (bundle IDs)
- GUI interface (SwiftUI preferred)
- Background monitoring loop (timer-based)
- Menu bar app optional

## Technical Constraints

- Use Swift
- Use native macOS APIs
- Use NSWorkspace notifications:
  - didActivateApplication
  - didLaunchApplication
  - didTerminateApplication

## Data Model

Use:

```swift
struct AppInfo {
    let bundleID: String
    let name: String
    let launchTime: Date
    var lastActiveTime: Date
    var isAllowlisted: Bool
}