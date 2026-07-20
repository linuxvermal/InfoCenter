pragma Singleton

import QtQuick

/*
    KeyboardNavigation.qml

    Responsibility

        Own keyboard navigation state.

    Does NOT

        Know about modules.

        Know about widgets.

        Handle business logic.

    Used by

        NetworkConnectivity.qml
*/

QtObject {

    id: root

    //
    // Keyboard Modes
    //

    readonly property int listMode: 0
    readonly property int buttonMode: 1
    readonly property int inputMode: 2

    //
    // Current State
    //

    property int currentMode: listMode
    property int previousMode: listMode

    //
    // Signals
    //

    signal modeChanged(int oldMode, int newMode)

    //
    // Mode Management
    //

    function setMode(mode) {

        if (currentMode === mode)
            return

        previousMode = currentMode
        currentMode = mode

        modeChanged(previousMode, currentMode)

    }

}
