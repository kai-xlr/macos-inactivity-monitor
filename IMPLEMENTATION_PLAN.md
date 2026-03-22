# Implementation Plan

## Phase 1: Setup
- Create macOS project
- Choose AppKit or SwiftUI
- Configure background mode

## Phase 2: App Monitoring
- Fetch running apps via NSWorkspace
- Filter regular apps
- Track launch events
- Track termination events

## Phase 3: Activity Tracking
- Listen for active app changes
- Store last active timestamps
- Maintain app dictionary

## Phase 4: Timer Loop
- Run every 60 seconds
- Evaluate inactivity conditions

## Phase 5: Alert System
- Create NSAlert popup
- Add action buttons

## Phase 6: Process Control
- Implement terminate()
- Implement forceTerminate()

## Phase 7: Allowlist
- Store bundle IDs
- Persist via UserDefaults

## Phase 8: GUI
- Dashboard view
- Settings view
- Allowlist editor

## Phase 9: Polish
- Error handling
- UX improvements
- Edge cases