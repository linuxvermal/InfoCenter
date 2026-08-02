pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    id: provider

    ////////////////////////////////////////////////////////
    // Battery
    ////////////////////////////////////////////////////////

    property int percent: 0
    property string state: "--"
    property string timeRemaining: "--"

    property string batteryHealth: "--"
    property string batteryCycles: "--"

    ////////////////////////////////////////////////////////
    // Update Functions
    ////////////////////////////////////////////////////////

    function updateBattery() {

        if (!batteryProcess.running)
            batteryProcess.running = true

    }

    ////////////////////////////////////////////////////////
    // Scheduler
    ////////////////////////////////////////////////////////

    Timer {

        interval: 5000

        running: true

        repeat: true

        triggeredOnStart: true

        onTriggered: provider.updateBattery()

    }

    ////////////////////////////////////////////////////////
    // Battery Process
    ////////////////////////////////////////////////////////

    Process {

        id: batteryProcess

        command: [

            "sh",

            "-c",

            "cat /sys/class/power_supply/BAT0/capacity; \
            cat /sys/class/power_supply/BAT0/status; \
            cat /sys/class/power_supply/BAT0/charge_full; \
            cat /sys/class/power_supply/BAT0/charge_full_design; \
            cat /sys/class/power_supply/BAT0/cycle_count; \
            cat /sys/class/power_supply/BAT0/charge_now; \
            cat /sys/class/power_supply/BAT0/current_now"

        ]

        stdout: StdioCollector {

            onStreamFinished: {

              let lines = this.text.trim().split("\n")

            if (lines.length >= 7) {

              provider.percent = parseInt(lines[0])

              provider.state = lines[1]

              let chargeFull = Number(lines[2])

              let chargeFullDesign = Number(lines[3])

              let cycleCount = lines[4]

              let chargeNow = Number(lines[5])

              let currentNow = Number(lines[6])

            if (chargeFull > 0 && chargeFullDesign > 0)

              provider.batteryHealth =
              Math.round(chargeFull / chargeFullDesign * 100) + "%"

            else

              provider.batteryHealth = "--"

              provider.batteryCycles = cycleCount

            if (provider.state === "Full") {

              provider.timeRemaining = "--"

            } else if (provider.state === "Charging") {

            if (currentNow > 0) {

              let hours = (chargeFull - chargeNow) / currentNow

              let h = Math.floor(hours)

              let m = Math.floor((hours - h) * 60)

            provider.timeRemaining = h + "h " + m + "m"

            } else {

            provider.timeRemaining = "--"

        }

            } else if (provider.state === "Discharging") {

            if (currentNow > 0) {

              let hours = chargeNow / currentNow

              let h = Math.floor(hours)

              let m = Math.floor((hours - h) * 60)

            provider.timeRemaining = h + "h " + m + "m"

            } else {

            provider.timeRemaining = "--"

            }

            } else {

            provider.timeRemaining = "--"

                }
 
              }

            }

        }

    }

}
