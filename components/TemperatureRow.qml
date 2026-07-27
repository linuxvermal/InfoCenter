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

    ////////////////////////////////////////////////////////
    // Temperature Colors
    ////////////////////////////////////////////////////////

    function temperatureColor(tempString, warning, critical) {

        let value = parseInt(tempString)

        if (isNaN(value))
            return Theme.noncritical

        if (value >= critical)
            return Theme.critical

        if (value >= warning)
            return Theme.warning

        return Theme.noncritical

    }

    property color cpuColor:
        temperatureColor(cpuTemp, 158, 185)

    property color gpuColor:
        temperatureColor(gpuTemp, 158, 181)

    property color ssdColor:
        temperatureColor(ssdTemp, 140, 158)

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
