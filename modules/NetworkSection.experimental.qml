import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../theme"
import "../components"
import "../providers"

Column {
    id: root

    width: parent ? parent.width : 0
    spacing: Theme.sectionSpacing

    readonly property var filteredInterfaces: {
        var list = []
        var source = NetworkProvider.interfaces || []

        for (var i = 0; i < source.length; ++i) {
            var iface = source[i]
            var name = iface.name || iface.interfaceName || ""

            if (name === "lo")
                continue

            if (name.indexOf("p2p-dev-") === 0)
                continue

            if (iface.isP2P === true)
                continue

            list.push(iface)
        }

        var connected = []
        var disconnected = []

        for (var j = 0; j < list.length; ++j) {
            if (list[j].connected)
                connected.push(list[j])
            else
                disconnected.push(list[j])
        }

        return connected.concat(disconnected)
    }

    SectionTitle {
        title: "NETWORK (" + root.filteredInterfaces.length + ")"
    }

    Text {
        visible: root.filteredInterfaces.length === 0
        text: "No network interfaces detected"
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.normalSize
    }

    Loader {
        visible: root.filteredInterfaces.length > 0
        width: parent.width

        sourceComponent: root.filteredInterfaces.length > 2 ? scrollComponent : normalComponent
    }

    Component {
        id: normalComponent

        Column {
            width: root.width
            spacing: Theme.sectionSpacing

            Repeater {
                model: root.filteredInterfaces

                NetworkInterfaceCard {
                    width: parent.width
                    interfaceData: modelData
                }
            }
        }
    }

    Component {
        id: scrollComponent

        ScrollView {
            width: root.width
            implicitHeight: 320
            clip: true

            Column {
                width: parent.width
                spacing: Theme.sectionSpacing

                Repeater {
                    model: root.filteredInterfaces

                    NetworkInterfaceCard {
                        width: parent.width
                        interfaceData: modelData
                    }
                }
            }
        }
    }
}
