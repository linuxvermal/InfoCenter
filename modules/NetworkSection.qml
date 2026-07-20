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

    SectionTitle {

        title: "NETWORK"

    }

    //
    // WiFi
    //

    Column {

        visible: NetworkProvider.connectionType === "WiFi" && !root.showNetworks

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

                text: NetworkProvider.ssid

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

                text: NetworkProvider.signal + "%"

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

                text: NetworkProvider.ip

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

                text: "WiFi"

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

        NetworkConnectivity {

                id: connectivity

                visible: root.showNetworks

                width: parent.width

        onCancelRequested: {

                      root.showNetworks = false

        }

        onConnectionSucceeded: {

                     root.showNetworks = false

        }

    }

    //
    // Ethernet
    //

    Column {

        visible: NetworkProvider.connectionType === "Ethernet" && !root.showNetworks

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

                text: NetworkProvider.ethernetSpeed

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

                text: NetworkProvider.ip

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

                text: "Ethernet"

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

        visible: NetworkProvider.connectionType === "Offline" && !root.showNetworks

        width: parent.width

        spacing: 6


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

    }


    Component.onCompleted: {

        NetworkProvider.refresh()

    }

}
