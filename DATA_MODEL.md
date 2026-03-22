# Data Model

## AppInfo

Represents a monitored application.

```swift
struct AppInfo {
    let bundleID: String
    let name: String
    let launchTime: Date
    var lastActiveTime: Date
    var isAllowlisted: Bool
}

{
  "allowedApps": [
    "com.apple.Safari",
    "com.apple.Terminal"
  ]
}