pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: provider

    property string connectionType: "Offline"
    property string ssid: "--"
    property int signal: 0
    property string ip: "--"
    property string ethernetSpeed: "--"

    property string wifiInterface: ""
    property string ethernetInterface: ""

    property var availableNetworks: []
    property bool scanning: false

    signal connectionSucceeded()
    signal connectionFailed()
    signal scanFinished()

    function refresh() {

        if (!refreshProcess.running)
            refreshProcess.running = true
    }

    function scan() {

        if (scanProcess.running)
            return

              provider.scanning = true

              scanProcess.running = true
    }

    function connect(ssid, password) {
        connectProcess.command = [
            "sh",
            "-c",
            "nmcli device wifi connect '" + ssid + "' password '" + password + "'"
        ]
        connectProcess.running = true
    }

    function resetState() {
        connectionType = "Offline"
        ssid = "--"
        signal = 0
        ip = "--"
        ethernetSpeed = "--"
        wifiInterface = ""
        ethernetInterface = ""
    }

    function parseRefresh(text) {

        resetState()

        let lines = text.trim().split("\n")

        for (let line of lines) {
            if (line.length === 0)
                continue

            let p = line.split(":")

            if (p.length < 4)
                continue

            let dev = p[0]
            let type = p[1]
            let state = p[2]
            let conn = p[3]

            if (type === "wifi") {
                wifiInterface = dev
                if (state === "connected") {
                    connectionType = "WiFi"
                    ssid = conn
                }
            }

            if (type === "ethernet") {
                ethernetInterface = dev
                if (state === "connected")
                    connectionType = "Ethernet"
            }
        }

            if (connectionType === "WiFi") {
                wifiProcess.command = [
                   "sh",
                   "-c",
                   "iw dev " + wifiInterface + " link; nmcli -g IP4.ADDRESS device show " + wifiInterface
            ]

                wifiProcess.running = true
          } else if (connectionType === "Ethernet") {
                ethernetProcess.command = [
                  "sh","-c",
                  "cat /sys/class/net/" + ethernetInterface + "/speed 2>/dev/null;nmcli -g IP4.ADDRESS device show " + ethernetInterface
            ]
                ethernetProcess.running = true
        }
    }

    function parseWifi(text) {

    let lines = text.trim().split("\n")

    signal = 0
    ip = "--"

    for (let line of lines) {

        line = line.trim()

        if (line.startsWith("SSID:")) {

            ssid = line.substring(5).trim()

        }

        else if (line.startsWith("signal:")) {

            let match = line.match(/(-?\d+)/)

            if (match) {

                let dbm = parseInt(match[1])

                //
                // Convert dBm to an approximate percentage.
                //
                signal = Math.max(
                    0,
                    Math.min(
                        100,
                        2 * (dbm + 100)
                    )
                )

            }

        }

        else if (line.indexOf("/") !== -1) {

            ip = line

        }

    }

  }

    function parseEthernet(text) {
        let lines = text.trim().split("\n")
        ethernetSpeed = (lines.length > 0 && lines[0] !== "") ? lines[0] + " Mbps" : "--"
        ip = (lines.length > 1 && lines[1] !== "") ? lines[1] : "--"
    }

    function parseScan(text) {
        let map = {}
        for (let line of text.trim().split("\n")) {
            if (line === "") continue
            let p = line.split(":")
            if (p.length < 4) continue
            let name = p[0]
            if (name === "" || name === "--" || name === "<hidden>") continue
            if (name.startsWith("DIRECT-")) continue

            let obj = {
                ssid: name,
                signal: parseInt(p[1]),
                secure: p[2] !== "",
                connected: p[3] === "yes",
                saved: false
            }

            if (!(name in map) || obj.signal > map[name].signal)
                map[name] = obj
        }

        let list = []
        for (let k in map)
            list.push(map[k])

        list.sort(function(a, b) {

    //
    // Connected network always first.
    //
             if (a.connected && !b.connected)
                return -1

             if (!a.connected && b.connected)
                return 1

    //
    // Otherwise sort by signal strength.
    //
                return b.signal - a.signal

              })

        availableNetworks = list

        provider.scanning = false
        provider.scanFinished()
    }

    Process {
        id: refreshProcess
        command: ["sh","-c","nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device"]
        stdout: StdioCollector {
            onStreamFinished: provider.parseRefresh(this.text)
        }
    }

    Process {
        id: wifiProcess
        stdout: StdioCollector {
            onStreamFinished: provider.parseWifi(this.text)
        }
    }

    Process {
        id: ethernetProcess
        stdout: StdioCollector {
            onStreamFinished: provider.parseEthernet(this.text)
        }
    }

    Process {
        id: scanProcess
        command: [
          "sh",
          "-c",
          "nmcli device wifi rescan >/dev/null 2>&1; sleep 1; nmcli -t -f SSID,SIGNAL,SECURITY,ACTIVE dev wifi"
    ]
        stdout: StdioCollector {
            onStreamFinished: provider.parseScan(this.text)
        }
    }


    Process {

        id: connectProcess

        onExited: function(exitCode, exitStatus) {

            provider.refresh()

        if (exitCode === 0) {

            provider.connectionSucceeded()

        } else {

            provider.connectionFailed()

        }

    }

  }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: provider.refresh()
    }
}
