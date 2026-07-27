import QtQuick
import QtQuick.Layouts

import "../theme"
import "../components"
import "../providers"

Column {

    id: root

    width: parent ? parent.width : 0

    spacing: 8

    property bool showNetworks: false

    readonly property var activeInterfaces: NetworkProvider.interfaces.filter(function(i){ return i.connected })
    readonly property var activeWifi: activeInterfaces.filter(function(i){ return i.type==="wifi" })
    readonly property var activeEthernet: activeInterfaces.filter(function(i){ return i.type==="ethernet" })
    readonly property int activeCount: activeInterfaces.length

    readonly property var wifi:
    activeWifi.length > 0 ? activeWifi[0] : null

    readonly property var ethernet:
    activeEthernet.length > 0 ? activeEthernet[0] : null

    SectionTitle {

        title: "NETWORK (" + root.activeCount + ")"

    }

    //
    // WiFi
    //

    Column {

        visible: root.activeWifi.length > 0 && !root.showNetworks

        width: parent.width

        spacing: 6


        GridLayout {

            id: wifiGrid

            width: parent.width

            columns: 4

            columnSpacing: 8

            rowSpacing: 6

            property int labelWidth: 52
            property int valueWidth: 150


            Text {

                Layout.preferredWidth: wifiGrid.labelWidth

                text: "SSID"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 0
                Layout.column: 0

            }


            Text {

                Layout.preferredWidth: wifiGrid.valueWidth

                text: wifi ? wifi.ssid : "--"

                color: Theme.noncritical

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                elide: Text.ElideRight

                Layout.row: 0
                Layout.column: 1

            }


            Text {

                Layout.preferredWidth: wifiGrid.labelWidth

                text: "SIGNAL"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 1
                Layout.column: 0

            }


            Text {

                Layout.preferredWidth: wifiGrid.valueWidth

                text: wifi ? wifi.signal + "%" : "--"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 1
                Layout.column: 1

            }


            Text {

                Layout.preferredWidth: wifiGrid.labelWidth

                text: "IP"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 2
                Layout.column: 0

            }


            Text {

                Layout.preferredWidth: wifiGrid.valueWidth

                text: wifi ? wifi.ip : "--"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                elide: Text.ElideMiddle

                Layout.row: 2
                Layout.column: 1

            }
            
            Item {

                Layout.row: 0
                Layout.column: 2

                Layout.fillWidth: true

            }

        
            Text {

                Layout.row: 0
                Layout.column: 3

                text: "WiFi (1)"

                color: Theme.warning

                font.family: Theme.font
                font.pixelSize: Theme.normalSize

                Layout.alignment: Qt.AlignRight

            }

  }


        Item {

            height: 2

        }


        Row {

            width: parent.width


            Item {

                width: (parent.width - scanButton.width) / 2

                height: 1

            }


        ActionButton {

               id: scanButton

               text: "SCAN"

               onClicked: {

                 root.showNetworks = true

                 NetworkProvider.scan()

               }
        }

      }

    }


    //
    // Ethernet
    //

    Column {

        visible: root.activeEthernet.length > 0 && !root.showNetworks

        width: parent.width

        spacing: 6


        GridLayout {

            id: ethernetGrid

            width: parent.width

            columns: 4

            columnSpacing: 8

            rowSpacing: 6

            property int labelWidth: 52
            property int valueWidth: 150


            Text {

                Layout.preferredWidth: ethernetGrid.labelWidth

                text: "SPEED"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 0
                Layout.column: 0

            }


            Text {

                Layout.preferredWidth: ethernetGrid.valueWidth

                text: ethernet ? ethernet.speed : "--"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 0
                Layout.column: 1

            }


            Text {

                Layout.preferredWidth: ethernetGrid.labelWidth

                text: "IP"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 1
                Layout.column: 0

            }


            Text {

                Layout.preferredWidth: ethernetGrid.valueWidth

                text: ethernet ? ethernet.ip : "--"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                elide: Text.ElideMiddle

                Layout.row: 1
                Layout.column: 1

            }
            
            Item {

                Layout.row: 0
                Layout.column: 2

                Layout.fillWidth: true

            }

            Text {

                Layout.row: 0
                Layout.column: 3

                text: "Ethernet (" + root.activeEthernet.length + ")"

                color: Theme.warning

                font.family: Theme.font
                font.pixelSize: Theme.normalSize

                Layout.alignment: Qt.AlignRight

            }

        }

    }


    //
    // Offline
    //

    Column {

        visible: root.activeCount === 0 && !root.showNetworks

        width: parent.width

        spacing: 6

        onVisibleChanged: {

             if (visible)
                NetworkProvider.scan()

        }


        GridLayout {

            id: offlineGrid

            width: parent.width

            columns: 4

            columnSpacing: 8

            rowSpacing: 6

            property int labelWidth: 52
            property int valueWidth: 150

            Text {

                Layout.row: 0
                Layout.column: 0

                Layout.preferredWidth: offlineGrid.labelWidth

                text: "SSID"

                color: Theme.text

                font.family: Theme.font
                font.pixelSize: Theme.normalSize

            }

                Text {

                Layout.row: 0
                Layout.column: 1

                Layout.preferredWidth: offlineGrid.valueWidth

                text: "--"

                color: Theme.text

                font.family: Theme.font
                font.pixelSize: Theme.normalSize

            }

            Item {

                Layout.row: 0
                Layout.column: 2

                Layout.fillWidth: true

            }

            Text {

                Layout.row: 1
                Layout.column: 0

                Layout.preferredWidth: offlineGrid.labelWidth

                text: "SIGNAL"

                color: Theme.text

                font.family: Theme.font
                font.pixelSize: Theme.normalSize

            }

            Text {

                Layout.row: 1
                Layout.column: 1

                Layout.preferredWidth: offlineGrid.valueWidth

                text: "--"

                color: Theme.text

                font.family: Theme.font
                font.pixelSize: Theme.normalSize

            }

            Text {

                Layout.row: 0
                Layout.column: 3

                text: "Offline"

                color: Theme.critical

                font.family: Theme.font
                font.pixelSize: Theme.normalSize

                Layout.alignment: Qt.AlignRight

            }

            Text {

                Layout.preferredWidth: offlineGrid.labelWidth

                text: "IP"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize
                
                Layout.row: 2
                Layout.column: 0
            }


            Text {

                Layout.preferredWidth: offlineGrid.valueWidth

                text: "--"

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.normalSize

                Layout.row: 2
                Layout.column: 1
            }

        }

        Item {
            height: 8
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Theme.separator
        }

        Item {
            height: 8
        }

    }

    NetworkConnectivity {

        visible: root.showNetworks || root.activeCount === 0

        width: parent.width

        onCancelRequested: {
            root.showNetworks = false
        }

        onConnectionSucceeded: {
            root.showNetworks = false
            NetworkProvider.refresh()
        }

    }


    Component.onCompleted: {

        NetworkProvider.refresh()

    }

}
