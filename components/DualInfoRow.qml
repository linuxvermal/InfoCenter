import QtQuick
import QtQuick.Layouts
import "../theme"

Item {

    id: root

    property string leftLabel: ""
    property string leftValue: ""

    property string rightLabel: ""
    property string rightValue: ""

    implicitWidth: parent ? parent.width : 396
    implicitHeight: Theme.normalSize + 6


    RowLayout {

        anchors.fill: parent

        spacing: 20


        // Left label

        Text {

            text: root.leftLabel

            color: Theme.muted

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }


        // Left value

        Text {

            Layout.fillWidth: true

            text: root.leftValue

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

            elide: Text.ElideRight

        }


        // Right label

        Text {

            text: root.rightLabel

            color: Theme.muted

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }


        // Right value

        Text {

            Layout.fillWidth: true

            horizontalAlignment: Text.AlignRight

            text: root.rightValue

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

            elide: Text.ElideRight

        }

    }

}
