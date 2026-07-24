# InfoCenter

> A modular Information Center for **Quickshell** and **NixOS**,
> designed around clear architectural boundaries, reusable components,
> and a lightweight, persistent user experience.

------------------------------------------------------------------------

## Overview

InfoCenter is a persistent Quickshell application that provides system
information, notifications, and quick system controls.

Instead of creating and destroying windows, the application is started
once and shown or hidden through IPC. This makes opening the panel
effectively instantaneous.

The project is intentionally organized into small layers where every
component has a single responsibility.

## Features

-   Persistent Quickshell application
-   Modular QML architecture
-   Keyboard-first workflow
-   System monitoring
-   Audio controls
-   Battery monitoring
-   Network information
-   Power profile controls
-   Notification Center
-   Desktop popup notifications
-   Duplicate notification grouping
-   Popup queue
-   PEACE Mode

## Architecture

``` text
Hyprland
    │
    ▼
shell.qml
    │
    ▼
InfoCenter.qml
    │
    ▼
Modules
    │
    ▼
Providers
    │
    ▼
Core
    │
    ▼
Linux
```

Each layer depends only on the layer beneath it.

## Notification Architecture

``` text
NotificationServer
        │
        ▼
NotificationProvider
        │
        ├── NotificationSection
        │
        └── PopupManager
                │
                ▼
          PopupOverlay
                │
                ▼
        NotificationCard
```

### NotificationServer

Receives D-Bus notifications and emits normalized notification objects.

### NotificationProvider

Owns notification history, grouping, sorting, counts, removal, and
history.

### PopupManager

Owns popup presentation, queueing, timeout handling, duplicate popup
updates, and PEACE Mode.

### PopupOverlay

Creates popup windows for each monitor.

### NotificationCard

Reusable component for both popup and history presentation.

## Duplicate Notifications

Notifications are grouped by a logical key (application, summary, body,
urgency). Grouped notifications retain a stable logical ID so both
history and popups update in place.

## Popup Queue

-   Maximum visible popups: **4**
-   Additional notifications are queued.
-   Queued notifications start their timeout only after becoming
    visible.

## PEACE Mode

PEACE Mode suppresses desktop popups while continuing to store every
notification in history.

## Design Principles

-   One responsibility per component
-   Providers own data
-   UI owns presentation
-   Popup lifetime is independent of notification history
-   Keep features simple and maintainable

## Development Workflow

1.  One feature
2.  One file (or tightly related change)
3.  Test
4.  Freeze
5.  Continue

## Future

-   Fan monitoring
-   CPU frequency monitoring
-   Disk health
-   Additional hardware sensors
-   Expanded power management

## License

Add your preferred license here.
