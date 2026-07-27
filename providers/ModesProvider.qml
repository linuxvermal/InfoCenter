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
    // Night Mode Backend
    //

    property bool nightAvailable: false
    property string nightBackend: ""

    //
    // Keep PopupManager in sync
    //

    onPeaceEnabledChanged: {
        PopupManager.peaceMode = peaceEnabled
    }

    //
    // Detect Backend
    //

    function detectNightBackend() {

        if (!backendDetectProcess.running)
            backendDetectProcess.running = true

    }

    //
    // Refresh
    //

    function refresh() {

        switch (nightBackend) {

        case "hyprsunset":

            queryProcess.command = [

                "sh",

                "-c",

                "pgrep -x hyprsunset"

            ]

            break

        case "kde":

            queryProcess.command = [

                "sh",

                "-c",

                `
gdbus call \
--session \
--dest org.kde.KWin \
--object-path /org/kde/KWin/NightLight \
--method org.freedesktop.DBus.Properties.Get \
org.kde.KWin.NightLight running
`

            ]

            break

        default:

            nightEnabled = false
            return

        }

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

        switch (nightBackend) {

        case "hyprsunset":

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

            break

        case "kde":

            if (nightEnabled) {

                toggleProcess.command = [

                    "sh",

                    "-c",

                    `
qdbus-qt6 \
    org.kde.kglobalaccel \
    /component/kwin \
    invokeShortcut "Toggle Night Color"

notify-send "Night Light" "Off" -u low
`

                ]

            } else {

                toggleProcess.command = [

                    "sh",

                    "-c",

                    `
qdbus-qt6 \
    org.kde.kglobalaccel \
    /component/kwin \
    invokeShortcut "Toggle Night Color"

notify-send "Night Light" "On" -u low
`

                ]

            }

            break

        default:

            return

        }

        if (!toggleProcess.running)
            toggleProcess.running = true

    }

    //
    // Detect Night Mode Backend
    //

    Process {

        id: backendDetectProcess

        command: [

            "sh",

            "-c",

            `
if command -v hyprsunset >/dev/null 2>&1 && [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
    echo hyprsunset
elif command -v qdbus-qt6 >/dev/null 2>&1 && [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    echo kde
else
    echo none
fi
`

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                let backend = text.trim()

                provider.nightBackend = backend
                provider.nightAvailable = backend !== "none"

            }

        }

    }

    //
    // Query Night Mode
    //

    Process {

        id: queryProcess

        stdout: StdioCollector {

            onStreamFinished: {

                switch (provider.nightBackend) {

                case "hyprsunset":

                    provider.nightEnabled =
                        text.trim().length > 0

                    break

                case "kde":

                    provider.nightEnabled =
                        text.indexOf("true") !== -1

                    break

                default:

                    provider.nightEnabled = false

                    break

                }

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

            refreshDelay.restart()

        }

    }

    //
    // Allow backend time to update state
    //

    Timer {

        id: refreshDelay

        interval: 250

        repeat: false

        onTriggered: provider.refresh()

    }

    //
    // Poll backend
    //

    Timer {

        interval: 5000

        running: true

        repeat: true

        triggeredOnStart: true

        onTriggered: {

            provider.detectNightBackend()
            provider.refresh()

        }

    }

}
