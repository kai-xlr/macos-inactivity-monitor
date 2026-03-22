# macOS Inactivity Monitor

A background macOS utility that detects applications that have been open and inactive for a configurable period (default: 30 minutes), and prompts the user to close or force quit them.

## Features

- Detect inactive applications
- Popup alerts with actions:
  - Close app
  - Force quit
  - Ignore
- Allowlist system
- GUI interface
- Background monitoring
- Menu bar support (optional)

## Tech Stack

- Swift
- AppKit or SwiftUI
- NSWorkspace APIs
- Accessibility APIs (AXUIElement)

## Goals

- Reduce system clutter
- Improve performance
- Encourage intentional app usage