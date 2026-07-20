pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    id: provider

    //
    // Current Power Profile
    //

    property string profile: "balanced"

    //
    // Refresh
    //

    function refresh() {

        if (!queryProcess.running)
            queryProcess.running = true

    }

    //
    // Set Profile
    //

    function setProfile(mode) {

        profileProcess.command = [

            "sh",

            "-c",

            "powerprofilesctl set " + mode

        ]

        profileProcess.running = true

    }

    //
    // Query Current Profile
    //

    Process {

        id: queryProcess

        command: [

            "sh",

            "-c",

            "powerprofilesctl get"

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                let output = this.text.trim()

                if (output.length > 0)
                    provider.profile = output

            }

        }

    }

    //
    // Apply Changes
    //

    Process {

        id: profileProcess

        onExited: {

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
