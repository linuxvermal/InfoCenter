pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import "../core"

Singleton {

    id: provider

    ////////////////////////////////////////////////////////
    // Status
    ////////////////////////////////////////////////////////

    property bool ready: false
property bool hasNvidiaSmi: false

    ////////////////////////////////////////////////////////
    // Capabilities
    ////////////////////////////////////////////////////////

    property bool hasCpuTemperature: false
    property bool hasGpuTemperature: false
    property bool hasNvmeTemperature: false

    ////////////////////////////////////////////////////////
    // Public API
    ////////////////////////////////////////////////////////

    property real cpuTemperature: 0
    property real gpuTemperature: 0
    property real nvmeTemperature: 0

    ////////////////////////////////////////////////////////
    // Startup
    ////////////////////////////////////////////////////////

    Component.onCompleted: {

        nvidiaDetect.running = true

    }

    ////////////////////////////////////////////////////////
    // NVIDIA Detection
    ////////////////////////////////////////////////////////

    Process {

        id: nvidiaDetect

        command: [
            "sh",
            "-c",
            "command -v nvidia-smi >/dev/null 2>&1 && echo yes || echo no"
        ]

        stdout: StdioCollector {

            onStreamFinished: {

                provider.hasNvidiaSmi = this.text.trim() === "yes"

                if (HardwarePaths.ready)
                    provider.initialize()

            }

        }

    }

    ////////////////////////////////////////////////////////
    // Poll Timer
    ////////////////////////////////////////////////////////

    Timer {

        interval: 5000

        running: provider.ready

        repeat: true

        onTriggered: updateTemperatures()

    }

    ////////////////////////////////////////////////////////
    // Initialization
    ////////////////////////////////////////////////////////

    function initialize() {

        hasCpuTemperature = HardwarePaths.cpuTemp !== ""
        hasGpuTemperature =
                HardwarePaths.gpuTemp !== "" || hasNvidiaSmi
        hasNvmeTemperature = HardwarePaths.ssdTemp !== ""

        ready = true

        updateTemperatures()

    }

    ////////////////////////////////////////////////////////
    // Temperature Update
    ////////////////////////////////////////////////////////

    function updateTemperatures() {

        tempProcess.running = true

    }

    ////////////////////////////////////////////////////////
    // Temperature Process
    ////////////////////////////////////////////////////////

    Process {

        id: tempProcess

        command: [
            "sh",
            "-c",
            `
cpu="${HardwarePaths.cpuTemp}"
gpu="${HardwarePaths.gpuTemp}"
nvme="${HardwarePaths.ssdTemp}"

read_sensor() {
    if [ -n "$1" ] && [ -r "$1" ]; then
        cat "$1"
    else
        echo ""
    fi
}

gpu_value=""

if [ -n "$gpu" ] && [ -r "$gpu" ]; then

    gpu_value=$(cat "$gpu")

elif command -v nvidia-smi >/dev/null 2>&1; then

    gpu_value=$(nvidia-smi         --query-gpu=temperature.gpu         --format=csv,noheader,nounits)

    if [ -n "$gpu_value" ]; then
        gpu_value=$((gpu_value * 1000))
    fi

fi

echo "$(read_sensor "$cpu")|$gpu_value|$(read_sensor "$nvme")"
`
        ]

        stdout: StdioCollector {

            onStreamFinished: {

                let parts = this.text.trim().split("|")

                if (provider.hasCpuTemperature && parts.length > 0) {
                    let value = Number(parts[0])
                    if (!isNaN(value))
                        provider.cpuTemperature = value / 1000.0
                }

                if (provider.hasGpuTemperature && parts.length > 1) {
                    let value = Number(parts[1])
                    if (!isNaN(value))
                        provider.gpuTemperature = value / 1000.0
                }

                if (provider.hasNvmeTemperature && parts.length > 2) {
                    let value = Number(parts[2])
                    if (!isNaN(value))
                        provider.nvmeTemperature = value / 1000.0
                }

            }

        }

    }

    ////////////////////////////////////////////////////////
    // Wait for HardwarePaths
    ////////////////////////////////////////////////////////

    Connections {

        target: HardwarePaths

        function onReadyChanged() {

            if (HardwarePaths.ready && !provider.ready)
                provider.initialize()

        }

    }

}
