pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    id: provider

    //
    // Current Modes
    //

    property bool peaceEnabled: false
    property bool nightEnabled: false

    //
    // Keep PopupManager in sync
    //

    onPeaceEnabledChanged: {
        PopupManager.peaceMode = peaceEnabled
    }

    //
    // Refresh
    //

    function refresh() {

        if (!queryProcess.running)
            queryProcess.running = true

    }

    //
    // Toggle Peace
    //

    function togglePeace() {

        peaceEnabled = !peaceEnabled

    }

    //
    // Toggle Night
    //

    function toggleNight() {

        if (nightEnabled) {

            toggleProcess.command = [

                "sh",

                "-c",

                "pkill -9 hyprsunset && notify-send 'Night Light' 'Off' -u low"

            ]

        } else {

            toggleProcess.command = [

                "sh",

                "-c",

                "hyprsunset --temperature 4000 & notify-send 'Night Light' 'On' -u low"

            ]

        }

        toggleProcess.running = true

    }

    //
    // Query Night Mode
    //

    Process {

        id: queryProcess

        command: [

            "sh",

            "-c",

            "pgrep -x hyprsunset"

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                provider.nightEnabled = text.trim().length > 0

            }

        }

        onExited: function(exitCode, exitStatus) {

            if (exitCode !== 0)
                provider.nightEnabled = false

        }

    }

    //
    // Apply Changes
    //

    Process {

        id: toggleProcess

        onExited: function(exitCode, exitStatus) {

            provider.refresh()

        }

    }

    //
    // Timer
    //

    Timer {

        interval: 5000

        running: true

        repeat: true

        triggeredOnStart: true

        onTriggered: provider.refresh()

    }

}
