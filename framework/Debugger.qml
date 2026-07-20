pragma Singleton

import QtQuick

QtObject {

    id: root

    //
    // =====================================================
    // CONFIGURATION
    // =====================================================
    //

    property bool enabled: true

    //
    // =====================================================
    // DEBUG CHANNELS
    // =====================================================
    //

    property bool logTransitions: true
    property bool logEvents: true
    property bool logInspectors: true

    property bool logFocus: true
    property bool logKey: true
    property bool logNetwork: true
    property bool logAudio: true
    property bool logBattery: true
    property bool logPower: true

    //
    // =====================================================
    // RUNTIME STATE
    // =====================================================
    //

    property bool recording: false
    property int transitionNumber: 0

    //
    // =====================================================
    // TRANSITION RECORDER
    // =====================================================
    //

    function beginTransition(trigger, expected) {

        if (!enabled || !logTransitions)
            return

        transitionNumber++
        recording = true

        console.log("")
        console.log("====================================================")
        console.log("Transition #" + transitionNumber)
        console.log("")
        console.log("Trigger:")
        console.log("    " + trigger)
        console.log("")
        console.log("Expected:")
        console.log("    " + expected)

    }

    function beginSection(title) {

        if (!enabled || !logTransitions || !recording)
            return

        console.log("")
        console.log("----------------------------------------------------")
        console.log(title)

    }

    function endTransition() {

        if (!enabled || !logTransitions || !recording)
            return

        console.log("")
        console.log("====================================================")
        console.log("")

        recording = false

    }

    //
    // =====================================================
    // EVENT LOGGER
    // =====================================================
    //

    function canLog() {

        return enabled && logEvents

    }

    function log(channel, message) {

        if (!canLog())
            return

        console.log("[" + channel + "]", message)

    }

    function note(message) {

        if (!canLog())
            return

        console.log(message)

    }

    function focus(message) {

        if (!logFocus)
            return

        log("FOCUS", message)

    }

    function key(message) {

        if (!logKey)
            return

        log("KEY", message)

    }

    function network(message) {

        if (!logNetwork)
            return

        log("NETWORK", message)

    }

    function audio(message) {

        if (!logAudio)
            return

        log("AUDIO", message)

    }

    function battery(message) {

        if (!logBattery)
            return

        log("BATTERY", message)

    }

    function power(message) {

        if (!logPower)
            return

        log("POWER", message)

    }

    //
    // =====================================================
    // INSPECTORS
    // =====================================================
    //

    function inspectFocus(name, object) {

        if (!enabled || !logInspectors)
            return

        console.log("")
        console.log(name)
        console.log("    focus            =", object.focus)
        console.log("    activeFocus      =", object.activeFocus)
        console.log("    activeFocusOnTab =", object.activeFocusOnTab)
        console.log("    enabled          =", object.enabled)
        console.log("    visible          =", object.visible)

    }

}
