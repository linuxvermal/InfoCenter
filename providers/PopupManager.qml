pragma Singleton

import QtQuick
import Quickshell

Singleton {

    id: provider

    //----------------------------------------------------------------------
    // Active popup notifications
    //----------------------------------------------------------------------

    property var activeNotifications: []

    //----------------------------------------------------------------------
    // Public API
    //----------------------------------------------------------------------

    function show(notification) {

        activeNotifications = activeNotifications.concat([{
            notification: notification,
            shownAt: Date.now()
        }])

    }

    function dismiss(id) {

        activeNotifications =
            activeNotifications.filter(function(popup) {
                return popup.notification.id !== id
            })

    }

    function clear() {

        activeNotifications = []

    }

    //----------------------------------------------------------------------
    // Refresh
    //----------------------------------------------------------------------

    function refresh() {

        const now = Date.now()

        activeNotifications =
            activeNotifications.filter(function(popup) {

                return (now - popup.shownAt) < 5000

            })

    }

    //----------------------------------------------------------------------
    // Timer
    //----------------------------------------------------------------------

    Timer {

        interval: 100

        running: true

        repeat: true

        onTriggered: provider.refresh()

    }

}
