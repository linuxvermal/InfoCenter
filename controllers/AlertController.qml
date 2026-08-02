import QtQuick
import QtQml

import "../core"
import "../providers"

QtObject {

    id: root

    //
    // Tracks whether the initial warning
    // notification has already been shown.
    //
    property bool warningShown: false

    //
    // Tracks the last battery percentage where
    // a repeat critical notification occurred.
    //
    property int lastCriticalRepeat: -1

    //
    // Listen for battery changes.
    //
    property var batteryConnections: Connections {

        target: BatteryProvider

        function onPercentChanged() {
            root.evaluate()
        }

        function onStateChanged() {
            root.evaluate()
        }
    }

    //
    // Evaluate battery state against the
    // alert policy.
    //
    function evaluate() {

        console.log(
    "[AlertController]",
    BatteryProvider.percent,
    BatteryProvider.state
)

        //
        // Charging
        //
        if (BatteryProvider.state === "Charging") {

            AlertManager.removeAlert()

            warningShown = false
            lastCriticalRepeat = -1

            return
        }

        //
        // 30%
        //
        if (!warningShown &&
            BatteryProvider.percent <= 30 &&
            BatteryProvider.percent > 10) {

            AlertManager.showWarning()

            warningShown = true

            return
        }

        //
        // 10%
        //
        if (BatteryProvider.percent <= 10 &&
            BatteryProvider.percent >= 5) {

            AlertManager.showCritical()

            return
        }

        //
        // 4%
        //
        if (BatteryProvider.percent <= 4) {

            AlertManager.showEmergency()

            return
        }
    }
}
