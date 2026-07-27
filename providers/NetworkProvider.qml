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

    // Internal interface inventory (Commit 1)
    property var interfaceInventory: []
    property var interfaces: []

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

    // Reset interface inventory
        interfaceInventory = []
        interfaces = []
    }

    function createInterface(data){
        data = data || {}
        return {
            type: data.type || "",
            name: data.name || "",
            connected: !!data.connected,
            connection: data.connection || "",
            ssid: data.ssid !== undefined ? data.ssid : "--",
            signal: data.signal !== undefined ? data.signal : 0,
            speed: data.speed !== undefined ? data.speed : "--",
            ip: data.ip !== undefined ? data.ip : "--"
        }
    }


function rebuildInterfaces() {

        let snapshot = []
        for (let iface of interfaceInventory) {

            snapshot.push(createInterface({
                type: iface.type,
                name: iface.name,
                connected: iface.connected,
                connection: iface.connection,
                ssid: (iface.connected && iface.type==="wifi") ? ssid : "--",
                signal: (iface.connected && iface.type==="wifi") ? signal : 0,
                speed: (iface.connected && iface.type==="ethernet") ? ethernetSpeed : "--",
                ip: iface.connected ? ip : "--"
            }))
        }

        interfaces = snapshot

    }

    
    function parseRefresh(text) {

        resetState()

        let lines = text.trim().split("\n")
        let inventory = []

        for (let line of lines) {
            if (!line.length) continue
            let p=line.split(":")
            if (p.length<4) continue
            let dev=p[0], type=p[1], state=p[2], conn=p[3]
            let connected=(state==="connected")
            inventory.push({
                name:dev,
                type:type,
                connected:connected,
                connection:conn
            })


            if(type==="wifi" && connected){
                if(wifiInterface==="") wifiInterface=dev
                connectionType="WiFi"
                ssid=conn
            } else if(type==="ethernet" && connected){
                if(ethernetInterface==="") ethernetInterface=dev
                connectionType="Ethernet"
            }
        }

        interfaceInventory = inventory
        if (connectionType === "WiFi") {
            wifiProcess.command=["sh","-c","iw dev "+wifiInterface+" link; nmcli -g IP4.ADDRESS device show "+wifiInterface]
            wifiProcess.running=true
        } else if (connectionType==="Ethernet") {
            ethernetProcess.command=["sh","-c","cat /sys/class/net/"+ethernetInterface+"/speed 2>/dev/null; nmcli -g IP4.ADDRESS device show "+ethernetInterface]
            ethernetProcess.running=true
        } else {
            rebuildInterfaces()
        }
    }

    function parseWifiData(text) {

    let data = {
        ssid: ssid,
        signal: 0,
        ip: "--"
    }

    let lines = text.trim().split("\n")

    for (let line of lines) {

        line = line.trim()

        if (line.startsWith("SSID:")) {

            data.ssid = line.substring(5).trim()

        }

        else if (line.startsWith("signal:")) {

            let match = line.match(/(-?\d+)/)

            if (match) {

                let dbm = parseInt(match[1])

                data.signal = Math.max(
                    0,
                    Math.min(
                        100,
                        2 * (dbm + 100)
                    )
                )

            }

        }

        else if (line.indexOf("/") !== -1) {

            data.ip = line

        }

    }

    return data
}

function parseWifi(text) {

    let data = parseWifiData(text)

    ssid = data.ssid
    signal = data.signal
    ip = data.ip

    rebuildInterfaces()

}

function parseEthernetData(text) {
        let lines=text.trim().split("\n")
        return {speed:(lines.length>0&&lines[0]!==""?lines[0]+" Mbps":"--"), ip:(lines.length>1&&lines[1]!==""?lines[1]:"--")}
    }

function parseEthernet(text) {

    let data = parseEthernetData(text)

    ethernetSpeed = data.speed
    ip = data.ip

    rebuildInterfaces()

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
