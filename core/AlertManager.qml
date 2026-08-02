pragma Singleton

import QtQuick

import "../providers"

QtObject {

    id: manager

    property bool dismissed: false

    function showWarning() {

        NotificationProvider.addNotification({
            id: "battery",
            appName: "Info Center",
            summary: "Battery Low",
            body: "Battery is getting low.\nConnect AC power soon.",
            urgency: "warning",
            requiresAcknowledgement: true,
            timestamp: Date.now()
        })
    }

    function showCritical() {

        NotificationProvider.addNotification({
            id: "battery",
            appName: "Info Center",
            summary: "Battery Critical",
            body: "Save your work.\nConnect AC power now.",
            urgency: "critical",
            requiresAcknowledgement: true,
            timestamp: Date.now()
        })
    }

    function showEmergency() {

        NotificationProvider.addNotification({
            id: "battery",
            appName: "Info Center",
            summary: "Battery Critical",
            body: "Save your work immediately.\nConnect AC power now.",
            urgency: "critical",
            timestamp: Date.now(),
            requiresAcknowledgement: true,
            dismissible: false
        })
    }

    function removeAlert() {

        NotificationProvider.removeNotification("battery")
        dismissed = false
    }

    function dismissAlert() {

        dismissed = true
        NotificationProvider.removeNotification("battery")
    }

}
