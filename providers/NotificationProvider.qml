pragma Singleton

import QtQuick
import Quickshell

import "../core"
import "../providers"

Singleton {

    id: root

    //----------------------------------------------------------------------
    // Configuration
    //----------------------------------------------------------------------

    readonly property int maxNotifications: 50

    //----------------------------------------------------------------------
    // Public State
    //----------------------------------------------------------------------

    property var notifications: []

    //----------------------------------------------------------------------
    // Notification Input
    //----------------------------------------------------------------------

    Connections {

        target: NotificationServer

        function onNotificationReceived(notification) {
            root.addNotification(notification)
        }
    }

    //----------------------------------------------------------------------
    // Helpers
    //----------------------------------------------------------------------

    function urgencyPriority(notification) {

        switch (notification.urgency) {

        case "critical":
            return 0

        case "warning":
            return 1

        case "normal":
            return 2

        case "low":
            return 3

        default:
            return 4
        }
    }

    function notificationKey(notification) {

        return [

            notification.appName,
            notification.summary,
            notification.body,
            notification.urgency

        ].join("\u0001")
    }

    function sortNotifications(list) {

        list.sort(function(a, b) {

            const priorityDifference =
                root.urgencyPriority(a) -
                root.urgencyPriority(b)

            if (priorityDifference !== 0)
                return priorityDifference

            return b.timestamp - a.timestamp

        })

        return list
    }

    //----------------------------------------------------------------------
    // Public API
    //----------------------------------------------------------------------

    function addNotification(notification) {

        const key = notificationKey(notification)

        const updated = notifications.slice()

        let popupNotification

        const existing = updated.find(function(item) {

            return notificationKey(item) === key

        })

        if (existing) {

            const index = updated.indexOf(existing)

            updated.splice(index, 1)

            popupNotification = {

                id: notification.id,
                appName: existing.appName,
                summary: existing.summary,
                body: existing.body,
                urgency: existing.urgency,
                timestamp: notification.timestamp,
                count: (existing.count || 1) + 1

            }

            updated.unshift(popupNotification)

        } else {

            notification.count = 1

            popupNotification = notification

            updated.unshift(notification)

        }

        sortNotifications(updated)

        if (updated.length > maxNotifications)
            updated.length = maxNotifications

        notifications = updated

        PopupManager.show(popupNotification)
    }

    function removeNotification(id) {

        notifications = notifications.filter(function(item) {

            return item.id !== id

        })
    }

    function clear() {

        notifications = []
    }
}
