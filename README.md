# InfoCenter

> A modular Information Center for **Quickshell** and **NixOS**,
> designed around clear architectural boundaries, reusable components,
> and a lightweight, persistent user experience.

------------------------------------------------------------------------

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/fbb6a857-5440-417b-b4da-0db30e8cec69" />

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
Controllers
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

------------------------------------------------------------------------

## Recent Project Updates

### Platform Support

InfoCenter has been validated and actively developed on:

-   **Fedora 44**
-   **KDE Plasma 6.7**
-   Quickshell 0.3.x

The project continues to target modern Linux desktop environments using
Quickshell and Wayland compositors.

### Current Module Layout

``` text
InfoCenter/
├── components
│   ├── ActionButton.qml
│   ├── Divider.qml
│   ├── DualInfoRow.qml
│   ├── FocusRegion.qml
│   ├── Header.qml
│   ├── InfoRow.qml
│   ├── MiniStatMeter.qml
│   ├── NotificationCard.qml
│   ├── PasswordInput.qml
│   ├── PopupOverlay.qml
│   ├── qmldir
│   ├── SectionTitle.qml
│   ├── StatMeter.qml
│   ├── StatusBadge.qml
│   ├── TemperatureRow.qml
│   └── WifiNetworkRow.qml
├── controllers
│   ├── AlertController.qml
│   └── qmldir
├── core
│   ├── AlertManager.qml
│   ├── HardwarePaths.qml
│   ├── NotificationServer.qml
│   ├── qmldir
│   └── SystemPaths.qml
├── docs
│   ├── DEVELOPMENT_GUIDE.md
│   └── InfoCenter_Notification_Architecture.md
├── framework
│   ├── Debugger.qml
│   ├── KeyboardNavigation.qml
│   └── qmldir
├── InfoCenter.qml
├── modules
│   ├── AudioSection.qml
│   ├── BatterySection.qml
│   ├── ModesSection.qml
│   ├── NetworkConnectivity.qml
│   ├── NetworkInterfaceCard.qml
│   ├── NetworkSection.qml
│   ├── NotificationSection.qml
│   ├── qmldir
│   └── SystemSection.qml
├── providers
│   ├── AudioProvider.qml
│   ├── BatteryProvider.qml
│   ├── ModesProvider.qml
│   ├── NetworkProvider.qml
│   ├── NotificationProvider.qml
│   ├── PopupManager.qml
│   ├── PowerProvider.qml
│   ├── qmldir
│   ├── SensorProvider.qml
│   └── SystemProvider.qml
├── README.md
├── shell.qml
└── theme
    ├── qmldir
    └── Theme.qml
```

### Recent Improvements

-   Improved modular architecture and separation of responsibilities.
-   Faster persistent InfoCenter startup using IPC show/hide.
-   Redesigned SectionTitle component for improved consistency.
-   Improved InfoRow alignment and spacing.
-   Replaced the previous volume slider with a **VolumeMeter** for
    smoother volume feedback.
-   Updated power profile controls using ActionButton components.
-   Improved notification history, duplicate grouping, popup queueing,
    and PEACE Mode.
-   Improved network information handling.
-   Refined battery and system status presentation.
-   Consistent monospace styling throughout the interface.
-   Cleaner block-character system meters for CPU, RAM, Disk, Battery,
    and Audio.

### Directory Design Principles

-   Components provide reusable UI elements.
-   Modules present complete functional sections.
-   Providers own data acquisition and state.
-   UI remains presentation-focused.
-   Each component has a single responsibility.

### Roadmap

Planned future enhancements include:

-   Fan monitoring
-   CPU frequency monitoring
-   Disk SMART health
-   Additional hardware sensors
-   Better GPU monitoring
-   Enhanced network diagnostics
-   More configurable themes
-   Improved Fedora and KDE Plasma validation
-   Expanded documentation and developer guides

## 2026 Architecture Refactor

See `docs/InfoCenter_Notification_Architecture.md` for the complete
notification and battery alert architecture introduced during the 2026
refactor.
