pragma Singleton

import QtQuick
import Quickshell

Singleton {

    id: provider

    //----------------------------------------------------------------------
    // Configuration
    //----------------------------------------------------------------------

    property int maxVisible: 4

    property bool peaceMode: false

    //----------------------------------------------------------------------
    // State
    //----------------------------------------------------------------------

    property var activeNotifications: []

    property var pendingNotifications: []

    //----------------------------------------------------------------------
    // Private helpers
    //----------------------------------------------------------------------

    function activateNotification(notification) {

        activeNotifications = activeNotifications.concat([{
            notification: notification,
            shownAt: Date.now()
        }])

    }

    //----------------------------------------------------------------------
    // Public API
    //----------------------------------------------------------------------

    function show(notification) {

        // PEACE Mode suppresses desktop popups only.
        // Notifications have already been stored by NotificationProvider.

        if (peaceMode)
            return

        if (activeNotifications.length < maxVisible) {

            activateNotification(notification)

        } else {

            pendingNotifications =
                pendingNotifications.concat([notification])

        }

    }

    function dismiss(id) {

        activeNotifications =
            activeNotifications.filter(function(popup) {

                return popup.notification.id !== id

            })

        if (pendingNotifications.length > 0) {

            const notification = pendingNotifications[0]

            pendingNotifications =
                pendingNotifications.slice(1)

            activateNotification(notification)

        }

    }

    function clear() {

        activeNotifications = []

        pendingNotifications = []

    }

    //----------------------------------------------------------------------
    // Refresh
    //----------------------------------------------------------------------

    function refresh() {

        const now = Date.now()

        activeNotifications.forEach(function(popup) {

            if ((now - popup.shownAt) >= 5000) {

                dismiss(popup.notification.id)

            }

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
