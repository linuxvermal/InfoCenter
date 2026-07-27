pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: provider

    property string connectionType: "Offline"
    property string ssid: "--"
    property int signal: 0
    property string wifiInterface: ""
    property string ethernetInterface: ""

    // Internal interface inventory (Commit 1)
    property var interfaceInventory: []
    property var interfaces: []

    property var availableNetworks: []

    property bool scanning: false
    property var metadataQueue: []
    property int metadataGeneration: 0
    property var activeMetadataJob: null

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

        wifiInterface = ""
        ethernetInterface = ""

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
        let snapshot=[]
        for (let iface of interfaceInventory)
            snapshot.push(createInterface(iface))
        interfaces=snapshot
    }

    function runNextMetadataJob() {
        if (metadataQueue.length===0) { activeMetadataJob=null; rebuildInterfaces(); return }
        activeMetadataJob=metadataQueue.shift()
        if (activeMetadataJob.type==="wifi") {
            wifiProcess.command=["sh","-c","iw dev "+activeMetadataJob.iface.name+" link; nmcli -g IP4.ADDRESS device show "+activeMetadataJob.iface.name]
            wifiProcess.running=true
        } else {
            ethernetProcess.command=["sh","-c","cat /sys/class/net/"+activeMetadataJob.iface.name+"/speed 2>/dev/null; nmcli -g IP4.ADDRESS device show "+activeMetadataJob.iface.name]
            ethernetProcess.running=true
        }
    }

    
    function parseRefresh(text) {

        resetState()
        metadataGeneration++
        metadataQueue=[]
        activeMetadataJob=null

        let lines=text.trim().split("\n")
        let inventory=[]
        for (let line of lines){
            if(!line.length) continue
            let p=line.split(":")
            if(p.length<4) continue
            let iface=createInterface({name:p[0],type:p[1],connected:p[2]==="connected",connection:p[3]})
            inventory.push(iface)
            if(iface.connected){
                if(iface.type==="wifi"){ if(wifiInterface==="") wifiInterface=iface.name; connectionType="WiFi"}
                else if(iface.type==="ethernet"){ connectionType="Ethernet"}
                metadataQueue.push({generation:metadataGeneration,type:iface.type,iface:iface})
            }
        }
        interfaceInventory=inventory
        if(metadataQueue.length===0) rebuildInterfaces()
        else runNextMetadataJob()
    }

function parseWifiData(text) {

    let data = {
        ssid: ssid,
        signal: 0,
        ip: "--"
    }

    if (!text || text.trim() === "")
        return data

    let lines = text.trim().split("\n")

    for (let line of lines) {

        line = line.trim()

        if (line.startsWith("SSID:")) {

            let value = line.substring(5).trim()
            if (value !== "" && value !== "--")
                data.ssid = value

        }

        else if (line.startsWith("signal:")) {

            let match = line.match(/(-?\d+)/)

            if (match) {

                let dbm = parseInt(match[1])

                if (!isNaN(dbm)) {
                    data.signal = Math.max(
                        0,
                        Math.min(
                            100,
                            2 * (dbm + 100)
                        )
                    )
                }

            }

        }

        else if (line.indexOf("/") !== -1) {

            if (line !== "")
                data.ip = line

        }

    }

    return data
}

function parseWifi(text) {
    if(!activeMetadataJob||activeMetadataJob.generation!==metadataGeneration) return
    let d=parseWifiData(text)
    if(d.ssid!==""&&d.ssid!=="--") activeMetadataJob.iface.ssid=d.ssid
    activeMetadataJob.iface.signal=d.signal
    if(d.ip!=="--") activeMetadataJob.iface.ip=d.ip
    else if(!activeMetadataJob.iface.ip) activeMetadataJob.iface.ip=d.ip
    runNextMetadataJob()
}

function parseEthernetData(text) {
        let data={speed:"--",ip:"--"}
        if(!text||text.trim()==="") return data
        let lines=text.trim().split("\n")
        if(lines.length>0){
            let s=lines[0].trim()
            if(s!==""&&s!=="Unknown"&&s!=="-1"){
                let n=parseInt(s)
                if(!isNaN(n)&&n>=0) data.speed=n+" Mbps"
            }
        }
        if(lines.length>1){
            let ip=lines[1].trim()
            if(ip!==""&&ip!=="Unknown"&&ip!=="-1") data.ip=ip
        }
        return data
    }

function parseEthernet(text) {
    if(!activeMetadataJob||activeMetadataJob.generation!==metadataGeneration) return
    let d=parseEthernetData(text)
    if(d.speed!=="--") activeMetadataJob.iface.speed=d.speed
    else if(!activeMetadataJob.iface.speed) activeMetadataJob.iface.speed=d.speed
    if(d.ip!=="--") activeMetadataJob.iface.ip=d.ip
    else if(!activeMetadataJob.iface.ip) activeMetadataJob.iface.ip=d.ip
    runNextMetadataJob()
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
