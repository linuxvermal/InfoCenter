pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

    id: hardwarePaths

    ////////////////////////////////////////////////////////
    // Resolved Sensor Paths
    ////////////////////////////////////////////////////////

    property string cpuTemp: ""
    property string gpuTemp: ""
    property string ssdTemp: ""
    property string gpuBusy: ""

    property bool ready: false

    ////////////////////////////////////////////////////////
    // Startup
    ////////////////////////////////////////////////////////

    Component.onCompleted: {

        discoverSensors.running = true

    }

    ////////////////////////////////////////////////////////
    // Sensor Discovery
    ////////////////////////////////////////////////////////

    Process {

        id: discoverSensors

        command: [

            "sh",
            "-c",

            `

            find_sensor() {

                for wanted in "$@"; do

                    for d in /sys/class/hwmon/hwmon*; do

                        [ -f "$d/name" ] || continue

                        if [ "$(cat "$d/name")" = "$wanted" ]; then

                            if [ -f "$d/temp1_input" ]; then
                                echo "$d/temp1_input"
                                return
                            fi

                        fi

                    done

                done

            }

            find_gpu_busy() {

                for d in /sys/class/drm/card*/device; do

                    [ -f "$d/gpu_busy_percent" ] || continue

                    echo "$d/gpu_busy_percent"
                    return

                done

            }

            echo CPU=$(find_sensor k10temp coretemp zenpower)
            echo GPU=$(find_sensor amdgpu nvidia nouveau)
            echo SSD=$(find_sensor nvme)
            echo GPUBUSY=$(find_gpu_busy)

            `

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                let lines = this.text.trim().split("\n")

                for (let line of lines) {

                    let pair = line.split("=")

                    if (pair.length !== 2)
                        continue

                    switch (pair[0]) {

                    case "CPU":
                        hardwarePaths.cpuTemp = pair[1]
                        break

                    case "GPU":
                        hardwarePaths.gpuTemp = pair[1]
                        break

                    case "SSD":
                        hardwarePaths.ssdTemp = pair[1]
                        break

                    case "GPUBUSY":
                        hardwarePaths.gpuBusy = pair[1]
                        break

                    }

                }

                // Uncomment for debugging if needed.
                //
                // console.log("HardwarePaths:")
                // console.log("  CPU:", hardwarePaths.cpuTemp)
                // console.log("  GPU:", hardwarePaths.gpuTemp)
                // console.log("  SSD:", hardwarePaths.ssdTemp)
                // console.log("  GPU Busy:", hardwarePaths.gpuBusy)

                hardwarePaths.ready = true

            }

        }

    }

}
