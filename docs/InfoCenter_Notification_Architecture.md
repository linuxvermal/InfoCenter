# InfoCenter Notification & Battery Alert Architecture

> **Purpose:**\
> This document records the notification architecture and battery alert
> design decisions made during the 2026 refactor. It is intended as a
> quick reference for future development so architectural decisions do
> not need to be rediscovered.

------------------------------------------------------------------------

# High-Level Architecture

    Notification Source
            │
            ▼
    NotificationProvider
            │
            ├────────────────┐
            ▼                ▼
      PopupManager    Notification List
            │                │
            ▼                ▼
      PopupOverlay   NotificationSection

All notifications---including `notify-send` and battery alerts---use the
same notification pipeline.

Battery alerts are **not a special UI**. They are standard notifications
with battery-specific policy.

------------------------------------------------------------------------

# Popup vs. Information Center

These intentionally behave differently.

## Popup

Clicking **X** hides only the popup.

    NotificationCard
          │
    dismissRequested(id)
          │
          ▼
    PopupOverlay
          │
          ▼
    NotificationProvider.hidePopup(id)
          │
          ▼
    PopupManager.dismiss(id)

The notification **remains** in the Information Center.

------------------------------------------------------------------------

## Information Center

Clicking **X** permanently removes the notification.

    NotificationCard
          │
    dismissRequested(id)
          │
          ▼
    NotificationSection
          │
          ▼
    NotificationProvider.removeNotification(id)

------------------------------------------------------------------------

# Battery Alert Design

Battery alerts use the exact same notification framework.

Every alert is created using the same notification ID:

``` qml
id: "battery"
```

Therefore:

-   Warning
-   Critical
-   Emergency

do **not** create multiple battery notifications.

Instead, `NotificationProvider.addNotification()` finds the existing
notification with ID `"battery"` and updates it before showing the popup
again.

------------------------------------------------------------------------

# AlertController Responsibilities

    BatteryProvider
            │
            ▼
    currentSeverity()
            │
            ▼
    evaluate()
            │
            ▼
    AlertManager

Responsibilities:

-   Determine current battery severity.
-   Prevent duplicate alerts while remaining in the same severity.
-   Trigger AlertManager when severity changes.

Severity levels:

    0 = No active battery alert
    1 = Warning
    2 = Critical
    3 = Emergency

The controller tracks:

``` qml
lastSeverity
```

------------------------------------------------------------------------

# AlertManager Responsibilities

AlertManager converts battery severity into notifications.

Public API:

``` qml
showWarning()
showCritical()
showEmergency()
removeAlert()
```

------------------------------------------------------------------------

# NotificationProvider Responsibilities

NotificationProvider owns the notification list.

When `addNotification()` receives a notification with an existing ID:

    Existing notification found
            │
            ▼
    Replace notification contents
            │
            ▼
    PopupManager.show(updated notification)

This updates the existing battery notification instead of creating
duplicates.

------------------------------------------------------------------------

# PopupManager Responsibilities

PopupManager is responsible only for popup visibility.

    show(notification)

    dismiss(id)

It has no battery-specific logic.

------------------------------------------------------------------------

# Battery Alert Lifecycle

    Battery <= 30%
            │
            ▼
    Warning popup

    User clicks X

    ↓

    Popup disappears

    ↓

    Notification remains in Information Center

    ↓

    Battery <= 10%

    ↓

    Critical popup appears again

    ↓

    Notification updated

    ↓

    Battery <= 4%

    ↓

    Emergency popup appears again

    ↓

    Notification updated

    ↓

    AC adapter connected

    ↓

    removeAlert()

    ↓

    Battery notification removed

------------------------------------------------------------------------

# Architectural Principles

-   One notification framework for everything.
-   Battery alerts reuse the existing notification system.
-   Popup dismissal is **not** notification removal.
-   Information Center removal is permanent.
-   Battery notifications update using a single notification ID.
-   Controller determines policy.
-   AlertManager creates notifications.
-   NotificationProvider stores and updates notifications.
-   PopupManager controls popup visibility.

------------------------------------------------------------------------

# Legacy Code Removed During Refactor

The following legacy components were removed:

-   `warningShown`
-   `lastCriticalRepeat`
-   `dismissAlert()`

The battery controller was converted to a severity-based state machine
using:

``` qml
currentSeverity()
lastSeverity
```

------------------------------------------------------------------------

# Future Notes

When modifying the notification system, always verify:

1.  Popup X hides only the popup.
2.  Information Center X removes the notification.
3.  Battery alerts continue to reuse `id: "battery"`.
4.  NotificationProvider updates existing notifications instead of
    creating duplicates.
5.  Battery policy remains separate from popup presentation.

This document should be updated whenever the notification architecture
changes.
