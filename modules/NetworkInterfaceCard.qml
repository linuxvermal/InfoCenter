import QtQuick
import QtQuick.Layouts

import "../theme"
import "../components"

Column {
    id: root

    property var interfaceData

    width: parent ? parent.width : implicitWidth
    spacing: Theme.sectionSpacing

    function valueOrDefault(v) {
        return (v === undefined || v === null || v === "") ? "--" : v
    }

    function isWifi() {
        return interfaceData && interfaceData.type === "WiFi"
    }

    function isEthernet() {
        return interfaceData && interfaceData.type === "Ethernet"
    }

    SectionTitle {
        title: (root.interfaceData ? root.interfaceData.type : "--")
    }

    InfoRow {
        label: "NAME"
        value: root.valueOrDefault(root.interfaceData ? root.interfaceData.name : "--")
    }

    InfoRow {
        label: "STATUS"
        value: root.valueOrDefault(root.interfaceData ? root.interfaceData.status : "--")
    }

    Column {
        width: parent.width
        spacing: Theme.sectionSpacing
        visible: root.isWifi()

        InfoRow {
            label: "SSID"
            value: root.valueOrDefault(root.interfaceData ? root.interfaceData.ssid : "--")
        }

        InfoRow {
            label: "SIGNAL"
            value: root.valueOrDefault(root.interfaceData ? root.interfaceData.signal : "0%")
        }

        InfoRow {
            label: "IP"
            value: root.valueOrDefault(root.interfaceData ? root.interfaceData.ip : "--")
        }
    }

    Column {
        width: parent.width
        spacing: Theme.sectionSpacing
        visible: root.isEthernet()

        InfoRow {
            label: "SPEED"
            value: root.valueOrDefault(root.interfaceData ? root.interfaceData.speed : "--")
        }

        InfoRow {
            label: "IP"
            value: root.valueOrDefault(root.interfaceData ? root.interfaceData.ip : "--")
        }
    }

    Column {
        width: parent.width
        spacing: Theme.sectionSpacing
        visible: root.interfaceData && !root.isWifi() && !root.isEthernet()

        InfoRow {
            label: "CONNECTION"
            value: root.valueOrDefault(root.interfaceData ? root.interfaceData.connection : "--")
        }
    }
}
