# Product Specification

## Core Problem

Users leave applications open for long periods without interacting with them, leading to clutter and resource waste.

## Solution

A macOS app that:
1. Monitors running applications
2. Detects inactivity
3. Prompts user to close unused apps

## Key Features

### 1. Inactivity Detection
An app is considered inactive if:
- It has been open longer than a threshold (default: 30 minutes)
- It has not been the frontmost app for that duration

### 2. Alert System
When inactivity is detected:
- Show popup with:
  - Close App
  - Force Quit
  - Ignore

### 3. Allowlist
Users can exclude apps from monitoring.

### 4. GUI Interface
- View monitored apps
- Manage allowlist
- Configure timeout

### 5. Background Execution
- Runs continuously
- Optional menu bar app

## Non-Goals

- Deep system monitoring
- Network tracking
- Behavioral analytics