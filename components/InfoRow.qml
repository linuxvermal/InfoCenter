import QtQuick
import QtQuick.Layouts
import "../theme"

Item {

    id: root

    property string label: ""
    property string value: ""

    property int labelWidth: Theme.infoLabelWidth

    property color valueColor: Theme.text

    implicitWidth: parent ? parent.width : Theme.panelWidth
    implicitHeight: Theme.normalSize + 4


    RowLayout {

        anchors.fill: parent

        spacing: Theme.spacing


        Text {

            Layout.preferredWidth: root.labelWidth
            Layout.alignment: Qt.AlignLeft

            text: root.label

            color: Theme.muted

            font.family: Theme.font
            font.pixelSize: Theme.normalSize

            elide: Text.ElideRight

        }


        Text {

            Layout.fillWidth: true

            text: root.value

            color: root.valueColor

            font.family: Theme.font
            font.pixelSize: Theme.normalSize

            elide: Text.ElideRight

        }

    }

}
