import QtQuick
import QtQml

import "../core"
import "../providers"

QtObject {

    id: root

    //
    // Tracks the highest battery alert
    // severity that has been issued.
    //
    property int lastSeverity: 0

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
    // Determine the current battery alert
    // severity from the current battery state.
    //
    // Returns:
    //   0 = Normal / Charging
    //   1 = Warning   (<= 30%)
    //   2 = Critical  (<= 10%)
    //   3 = Emergency (<= 4%)
    //
    function currentSeverity() {

        if (BatteryProvider.state === "Charging") {

            return 0

        }

        if (BatteryProvider.percent <= 4) {

            return 3

        }

        if (BatteryProvider.percent <= 10) {

            return 2

        }

        if (BatteryProvider.percent <= 30) {

            return 1

        }

            return 0

        }

    //
    // Evaluate the current battery alert
    // severity and apply the alert policy.
    //
    function evaluate() {

        var severity = currentSeverity()

        if (severity === lastSeverity) {
        
            return
        
        }

        //
        // Normal / Charging
        //
        if (severity === 0) {

            AlertManager.removeAlert()

            lastSeverity = 0

            return

        }

        //
        // Warning
        //
        if (severity === 1) {

            AlertManager.showWarning()

            lastSeverity = 1

            return

        }

        //
        // Critical
        //
        if (severity === 2) {

            AlertManager.showCritical()

            lastSeverity = 2

            return

        }

        //
        // Emergency
        //
        if (severity === 3) {

            AlertManager.showEmergency()

            lastSeverity = 3

            return

        }
    }
}
