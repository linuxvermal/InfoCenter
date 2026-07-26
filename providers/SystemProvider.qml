pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../core"

Singleton {

    id: provider

    ////////////////////////////////////////////////////////
    // Identity
    ////////////////////////////////////////////////////////

    property string userName: "--"
    property string hostName: "--"

    ////////////////////////////////////////////////////////
    // Hardware
    ////////////////////////////////////////////////////////

    property string cpuModel: "--"
    property string gpuModel: "--"

    ////////////////////////////////////////////////////////
    // Runtime
    ////////////////////////////////////////////////////////

    property string kernel: "--"
    property string uptime: "--"

    ////////////////////////////////////////////////////////
    // Usage
    ////////////////////////////////////////////////////////

    property real cpuUsage: 0
    property real ramUsage: 0
    property real diskUsage: 0
    property real gpuUsage: 0

    ////////////////////////////////////////////////////////
    // Temperatures
    ////////////////////////////////////////////////////////

    property string cpuTemp: "--"
    property string gpuTemp: "--"
    property string ssdTemp: "--"

    ////////////////////////////////////////////////////////
    // Startup
    ////////////////////////////////////////////////////////

    Component.onCompleted: {

        loadIdentity()
        loadHardware()
        loadRuntime()

    }

    Timer {

    interval: 2000

    running: true

    repeat: true

    triggeredOnStart: true

    onTriggered: {

        updateUsage()
        updateGpu()

    }

}

    Timer {

    interval: 5000

    running: true

    repeat: true

    triggeredOnStart: true

    onTriggered: {

        updateTemperatures()

    }

}

    Timer {

    interval: 60000

    running: true

    repeat: true

    triggeredOnStart: true

    onTriggered: {

        updateRuntime()

    }

}

    ////////////////////////////////////////////////////////
    // Startup Functions
    ////////////////////////////////////////////////////////

    function loadIdentity() {

        userProcess.running = true
        hostProcess.running = true

    }

    function loadHardware() {

        cpuModelProcess.running = true
        gpuModelProcess.running = true

    }

    function loadRuntime() {

        kernelProcess.running = true
        uptimeProcess.running = true

    }

    ////////////////////////////////////////////////////////
    // Update Functions
    ////////////////////////////////////////////////////////

    function updateRuntime() {

        uptimeProcess.running = true

    }


    ////////////////////////////////////////////////////////
    // Identity Processes
    ////////////////////////////////////////////////////////

    Process {

        id: userProcess

        command: ["whoami"]

        stdout: StdioCollector {

            onStreamFinished: {

                provider.userName = this.text.trim()

            }

        }

    }


    Process {

        id: hostProcess

        command: ["hostname"]

        stdout: StdioCollector {

            onStreamFinished: {

                provider.hostName = this.text.trim()

            }

        }

    }


    ////////////////////////////////////////////////////////
    // Hardware Processes
    ////////////////////////////////////////////////////////

    Process {

        id: cpuModelProcess

        command: [
              "sh",
              "-c",
              "awk -F: '/model name/ {print $2; exit}' /proc/cpuinfo | sed 's/^ *//' | sed 's/(R)//g' | sed 's/(TM)//g' | sed 's/ CPU//g' | sed 's/@.*//' | sed 's/  */ /g' | sed 's/ *$//' | sed 's/ w\\/.*//'"
        ]

        stdout: StdioCollector {

            onStreamFinished: {

                provider.cpuModel = this.text.trim()

            }

        }

    }


    Process {

        id: gpuModelProcess

        command: [
             "sh",
             "-c",
             "lspci | grep -i 'vga\\|3d\\|display' | head -1"
        ]

        stdout: StdioCollector {

            onStreamFinished: {

                let gpu = this.text.trim()

                let nvidia = gpu.match(/\[(GeForce[^\]]+)\]/)
                if (nvidia) {
                    provider.gpuModel = "NVIDIA " + nvidia[1].replace("GeForce ", "")
                    return
                }

                let amd = gpu.match(/Radeon[^,\]]+/i)
                if (amd) {
                    provider.gpuModel = amd[0].trim()
                    return
                }

                let arc = gpu.match(/Arc\s+[A-Za-z0-9\- ]+/i)
                if (arc) {
                    provider.gpuModel = "Intel " + arc[0].trim()
                    return
                }

                let intel = gpu.match(/(UHD|Iris)[^,\]]+/i)
                if (intel) {
                    provider.gpuModel = "Intel " + intel[0].trim()
                    return
                }

                gpu = gpu.replace(/^.*?:\s*/, "").replace(/\(rev.*$/, "").trim()
                provider.gpuModel = gpu.length ? gpu : "Unknown"

            }

    }

    }


    ////////////////////////////////////////////////////////
    // Runtime Processes
    ////////////////////////////////////////////////////////

    Process {

        id: kernelProcess

        command: [

            "uname",
            "-r"

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                provider.kernel = this.text.trim()

            }

        }

    }


    Process {

        id: uptimeProcess

        command: [

            "sh",
            "-c",
            "awk '{days=int($1/86400); hours=int(($1%86400)/3600); mins=int(($1%3600)/60); printf \"%dd %dh %dm\", days, hours, mins}' /proc/uptime"

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                provider.uptime = this.text.trim()

            }

        }

    }

     ////////////////////////////////////////////////////////
    // Usage Processes
    ////////////////////////////////////////////////////////

    Process {

        id: statsProcess

        command: [

            "sh",
            "-c",
            "top -bn1 | grep 'Cpu(s)' | awk '{print $2}'; free | grep Mem | awk '{print $3/$2 * 100}'; df / | tail -1 | awk '{print $5}' | tr -d '%'"

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                let lines = this.text.trim().split("\n")

                if (lines.length >= 3) {

                    provider.cpuUsage = parseFloat(lines[0]) / 100
                    provider.ramUsage = parseFloat(lines[1]) / 100
                    provider.diskUsage = parseFloat(lines[2]) / 100

                }

            }

        }

    }


    Process {

        id: gpuProcess

        command: [

             "sh",
             "-c",

             `
             if [ -n "${HardwarePaths.gpuBusy}" ]; then
                cat "${HardwarePaths.gpuBusy}"
             fi
             `

        ]

        stdout: StdioCollector {

            onStreamFinished: {

                let value = this.text.trim()

                if (value.length > 0)
                    provider.gpuUsage = parseFloat(value) / 100

            }

        }

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
        if [ -n "${HardwarePaths.cpuTemp}" ]; then
            echo CPU $(cat "${HardwarePaths.cpuTemp}")
        fi

        if [ -n "${HardwarePaths.gpuTemp}" ]; then
            echo GPU $(cat "${HardwarePaths.gpuTemp}")
        fi

        if [ -n "${HardwarePaths.ssdTemp}" ]; then
            echo SSD $(cat "${HardwarePaths.ssdTemp}")
        fi
            `
        ]


        stdout: StdioCollector {

            onStreamFinished: {

                let lines = this.text.trim().split("\n")

                for (let line of lines) {

                    let parts = line.split(" ")

                    if (parts.length !== 2)
                        continue

                    let c = parseFloat(parts[1]) / 1000
                    let f = Math.round((c * 9 / 5) + 32) + "°F"

                    switch (parts[0]) {

                    case "CPU":
                        provider.cpuTemp = f
                        break

                    case "GPU":
                        provider.gpuTemp = f
                        break

                    case "SSD":
                        provider.ssdTemp = f
                        break

                    }

                }

            }

        }

    }


    ////////////////////////////////////////////////////////
    // Update Implementations
    ////////////////////////////////////////////////////////

    function updateUsage() {

        if (!statsProcess.running)
            statsProcess.running = true

    }

    function updateGpu() {

        if (!HardwarePaths.ready)
            return

        if (!gpuProcess.running)
            gpuProcess.running = true

    }

    function updateTemperatures() {

        if (!HardwarePaths.ready)
            return

        if (!tempProcess.running)
            tempProcess.running = true

    }

}
