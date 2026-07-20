import QtQuick

import "../theme"

Rectangle {
    id: root

    property string networkName: ""
    property int signalStrength: 0
    property bool secure: false
    property bool connected: false
    property bool selected: false
    property bool authenticationFailed: false

    signal clicked()

    width: parent ? parent.width : 0
    height: 26
    radius: 3

    color: "transparent"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        spacing: 6

        Text {
            width: 12
            text: root.selected ? ">" : " "
            color: Theme.accent
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            width: 18
            text: root.secure ? "󰌾" : ""
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            width: 250
            text: root.networkName
            elide: Text.ElideRight
            color: root.authenticationFailed && root.selected ? Theme.critical : root.connected ? Theme.noncritical : Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            width: 44
            horizontalAlignment: Text.AlignRight
            text: root.signalStrength + "%"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
            verticalAlignment: Text.AlignVCenter
        }
    }
}
