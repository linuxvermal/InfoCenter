pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    id: provider


    ////////////////////////////////////////////////////////
    // Audio State
    ////////////////////////////////////////////////////////

    property real volume: 0

    property bool muted: false

    property string outputName: ""


    ////////////////////////////////////////////////////////
    // Refresh
    ////////////////////////////////////////////////////////

    function refresh() {

        if (!volumeProcess.running)
            volumeProcess.running = true

        if (!deviceProcess.running)
            deviceProcess.running = true

    }


    ////////////////////////////////////////////////////////
    // Volume Query
    ////////////////////////////////////////////////////////

    Process {

        id: volumeProcess


        command: [

            "sh",

            "-c",

            "wpctl get-volume @DEFAULT_AUDIO_SINK@"

        ]


        stdout: StdioCollector {


            onStreamFinished: {


                let output = this.text.trim()


                if (output.length > 0) {


                    provider.muted =
                        output.includes("[MUTED]")


                    let match =
                        output.match(/Volume:\s([0-9.]+)/)


                    if (match) {

                        provider.volume =
                            Number(match[1])

                    }

                }

            }

        }

    }


    ////////////////////////////////////////////////////////
    // Output Device
    ////////////////////////////////////////////////////////

    Process {

        id: deviceProcess


        command: [

            "sh",

            "-c",

            "wpctl inspect @DEFAULT_AUDIO_SINK@"

        ]


        stdout: StdioCollector {


            onStreamFinished: {


                let output = this.text


                if (output.includes("bluez")) {

                    provider.outputName = "Bluetooth"

                }

                else if (output.includes("hdmi")) {

                    provider.outputName = "HDMI"

                }

                else if (output.includes("usb")) {

                    provider.outputName = "Headphones"

                }

                else {

                    provider.outputName = "Speakers"

                }

            }

        }

    }


    ////////////////////////////////////////////////////////
    // Control Helper
    ////////////////////////////////////////////////////////

    function runCommand(command) {

        controlProcess.command = [

            "sh",

            "-c",

            command

        ]

    controlProcess.running = true

    }

    ////////////////////////////////////////////////////////
    // Controls
    ////////////////////////////////////////////////////////


    function volumeUp() {

        runCommand("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")

    }


    function volumeDown() {

        runCommand("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")

    }


    function toggleMute() {

        runCommand("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")

    }


    ////////////////////////////////////////////////////////
    // Control Process
    ////////////////////////////////////////////////////////

    Process {

        id: controlProcess


        onExited: {

            provider.refresh()

        }

    }


    ////////////////////////////////////////////////////////
    // Timer
    ////////////////////////////////////////////////////////

    Timer {

        interval: 250

        running: true

        repeat: true

        triggeredOnStart: true


        onTriggered: {

            provider.refresh()

        }

    }
}
