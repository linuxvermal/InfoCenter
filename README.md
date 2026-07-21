# InfoCenter

## Overview

InfoCenter is a modular system information panel built with
**Quickshell** and **QML** for NixOS. It runs as a persistent background
application and is shown or hidden through IPC, making it fast to open
without restarting Quickshell.

The project is organized into small, focused layers:

-   **UI** displays information.
-   **Providers** gather system data.
-   **Core** discovers and stores shared system paths.
-   **Linux** exposes the underlying `/proc`, `/sys`, PipeWire, and
    NetworkManager interfaces.

## Architecture

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
    HardwarePaths / SystemPaths
        │
        ▼
    Linux

### Startup

1.  Hyprland launches `shell.qml`.
2.  `shell.qml` creates the persistent Quickshell application.
3.  IPC (`toggle`, `show`, `hide`) controls the InfoCenter window.
4.  The window is shown or hidden instantly because Quickshell never
    restarts.

## Project Structure

    InfoCenter/
    ├── shell.qml
    ├── InfoCenter.qml
    ├── components/
    ├── core/
    ├── framework/
    ├── modules/
    ├── providers/
    └── theme/

### shell.qml

Application entry point.

-   Creates the persistent application.
-   Owns the InfoCenter window.
-   Handles IPC.

### InfoCenter.qml

Main panel window.

-   Defines the overall layout.
-   Hosts each module.

### components/

Reusable UI widgets.

Examples:

-   Buttons
-   Headers
-   Meters
-   Info rows
-   Dividers

These contain presentation only and should not read system data
directly.

### modules/

Complete sections of the interface.

Examples:

-   System
-   Audio
-   Battery
-   Network

Modules assemble components and connect them to providers.

### providers/

Responsible for retrieving system information.

Examples:

-   CPU usage
-   Memory
-   Battery
-   Audio
-   Network

Providers know **how** to obtain data but not how to display it.

### core/

Shared services used throughout the project.

**HardwarePaths.qml**

-   Discovers dynamic hardware paths.
-   CPU temperature
-   GPU temperature
-   SSD temperature
-   GPU utilization

**SystemPaths.qml**

Stores static Linux paths such as:

-   `/proc/stat`
-   `/proc/meminfo`
-   `/proc/uptime`

### framework/

Application infrastructure.

Examples:

-   Keyboard navigation
-   Debugging helpers

### theme/

Centralized colors, fonts, spacing, and sizing.

## Design Principles

The project follows a layered architecture:

    UI
     │
    Providers
     │
    Core
     │
    Linux

Guidelines:

-   Components should not collect data.
-   Modules should not discover hardware paths.
-   Providers should not contain UI.
-   Core should only expose shared services and paths.
-   Each layer depends only on the layer beneath it.

## Future

The architecture is intended to grow without major restructuring. Future
additions may include:

-   Notification Center
-   Fan monitoring
-   CPU frequency monitoring
-   Disk health
-   Additional hardware discovery
