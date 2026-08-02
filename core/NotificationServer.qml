pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {

    id: root

    //----------------------------------------------------------------------
    // Public API
    //----------------------------------------------------------------------

    signal notificationReceived(var notification)

    //----------------------------------------------------------------------
    // Notification Server
    //----------------------------------------------------------------------

    NotificationServer {

        id: server

        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: false

        onNotification: function(notification) {

            root.notificationReceived(
                root.translateNotification(notification)
            )
        }
    }

    //----------------------------------------------------------------------
    // Translation
    //----------------------------------------------------------------------

    function translateNotification(notification) {

        return {

            id: String(notification.id),

            appName: notification.appName || "",

            summary: notification.summary || "",

            body: notification.body || "",

            urgency: urgencyString(notification.urgency),

            timestamp: Date.now()
        }
    }

    function urgencyString(urgency) {

        switch (urgency) {

        case NotificationUrgency.Low:
            return "low"

        case NotificationUrgency.Critical:
            return "critical"

        default:
            return "normal"
        }
    }
}
