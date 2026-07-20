import QtQuick
import "../theme"

Item {

    id: root

    property string label: ""
    property real value: 0

    width: parent.width
    height: 22

    StatMeter {

        anchors.fill: parent

        label: root.label
        value: root.value
    }

}
