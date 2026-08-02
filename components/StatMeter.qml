import QtQuick
import "../theme"


Item {

    id: root

    property string label: "STAT"
    property real value: 0
    property color barColor: Theme.bar
    property bool adaptiveColor: false
    property string state: ""
    property int barLength: 14
    property string processName: ""
    property string processCpu: ""

    width: 200

    height: 22


    Row {

    anchors.verticalCenter: parent.verticalCenter

    spacing: 4


    Text {

        width: 35

        text: root.label

        color: Theme.text

        font.family: Theme.font

        font.pixelSize: Theme.normalSize
    }


    Text {

        width: 108

        color: {

        if (!root.adaptiveColor)
        return root.barColor

        if (root.state === "Charging")
        return Theme.noncritical

        if (root.state === "Full")
        return Theme.noncritical

        if (root.value > 0.60)
        return Theme.noncritical

        if (root.value > 0.30)
        return Theme.warning

        return Theme.critical

    }

        font.family: Theme.font

        font.pixelSize: Theme.normalSize


        text: {

            let filled =
                Math.round(root.value * root.barLength)

            let bar = ""

            for (let i = 0; i < root.barLength; ++i)

                bar += (i < filled) ? "█" : "░"

            return bar

        }
    }


    Text {

        width: 30

        horizontalAlignment: Text.AlignRight

        text: Math.round(root.value * 100) + "%"

        color: Theme.text

        font.family: Theme.font

        font.pixelSize: Theme.normalSize
    }


    Text {

        visible: root.processName.length > 0

        width: 110

        leftPadding: 12

        text: root.processName

        color: Theme.muted

        font.family: Theme.font

        font.pixelSize: Theme.normalSize

        elide: Text.ElideRight
    }


    Text {

        visible: root.processCpu.length > 0

        width: 35

        horizontalAlignment: Text.AlignRight

        text: root.processCpu

        color: Theme.text

        font.family: Theme.font

        font.pixelSize: Theme.normalSize
    }
}
}
