import QtQuick
import QtQuick.Layouts
import "../theme"

Item {

    id: root

    ////////////////////////////////////////////////////////
    // Properties
    ////////////////////////////////////////////////////////

    property string cpuTemp: "--"

    property string gpuTemp: "--"

    property string ssdTemp: "--"

    property color cpuColor: Theme.noncritical

    property color gpuColor: Theme.noncritical

    property color ssdColor: Theme.noncritical

    ////////////////////////////////////////////////////////

    implicitWidth: parent ? parent.width : 396

    implicitHeight: 20


    RowLayout {

        anchors.fill: parent

        spacing: 0


        Text {

            Layout.fillWidth: true

            text: "CPU " + root.cpuTemp

            color: root.cpuColor

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }


        Text {

            Layout.fillWidth: true

            horizontalAlignment: Text.AlignHCenter

            text: "GPU " + root.gpuTemp

            color: root.gpuColor

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }


        Text {

            Layout.fillWidth: true

            horizontalAlignment: Text.AlignRight

            text: "SSD " + root.ssdTemp

            color: root.ssdColor

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

    }

}
