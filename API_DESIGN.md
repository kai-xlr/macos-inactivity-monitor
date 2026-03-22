# API Design

## MonitorEngine

Responsibilities:
- Track running apps
- Update activity timestamps

### Methods

- startMonitoring()
- stopMonitoring()
- getRunningApps()

---

## ActivityTracker

- handleAppActivated(app)
- updateLastActiveTime(bundleID)

---

## AllowlistService

- addApp(bundleID)
- removeApp(bundleID)
- isAllowlisted(bundleID)

---

## ProcessService

- terminate(app)
- forceTerminate(app)

---

## AlertService

- showAlert(for app)