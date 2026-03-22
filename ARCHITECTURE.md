# Architecture

## Overview

The app consists of three main components:

### 1. Monitor Engine
Tracks:
- Running applications
- Active application changes
- Time since last interaction

### 2. Decision Engine
Determines:
- Which apps are inactive
- Whether to trigger alerts

### 3. Action Handler
Handles:
- Graceful termination
- Force termination

---

## Flow

1. App launches
2. Start monitoring loop (timer)
3. Track active app changes
4. Update timestamps
5. Evaluate inactivity
6. Trigger alert if needed
7. Execute user action

---

## Modules

/Core
- MonitorEngine.swift
- ActivityTracker.swift

/Services
- AllowlistService.swift
- ProcessService.swift

/UI
- DashboardView.swift
- SettingsView.swift

/Models
- AppInfo.swift