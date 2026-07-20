import QtQuick
import QtQuick.Layouts

import "../theme"
import "../components"
import "../providers"

Column {

    id: root

    spacing: 8

    width: parent ? parent.width : 0

    SectionTitle {

        title: "SYSTEM"

    }

    //
    // Live performance
    //

    GridLayout {

        width: parent.width

        columns: 2

        columnSpacing: 18

        rowSpacing: 4

        MiniStatMeter {

            label: "CPU"
            value: SystemProvider.cpuUsage

        }

        MiniStatMeter {

            label: "RAM"
            value: SystemProvider.ramUsage

        }

        MiniStatMeter {

            label: "SSD"
            value: SystemProvider.diskUsage

        }

        MiniStatMeter {

            label: "GPU"
            value: SystemProvider.gpuUsage

        }

    }

    //
    // Temperatures
    //

    TemperatureRow {

        cpuTemp: SystemProvider.cpuTemp
        gpuTemp: SystemProvider.gpuTemp
        ssdTemp: SystemProvider.ssdTemp

    }

    //
    // System information
    //

    GridLayout {
        
        id: infoGrid

        width: parent.width

        columns: 5

        columnSpacing: 10
        rowSpacing: 6

        property int labelWidth: 34
        property int valueWidth: 118
        property int spacerWidth: 20

        // USER

        Text {
            Layout.preferredWidth: infoGrid.labelWidth
            text: "USER"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        Text {
            Layout.preferredWidth: infoGrid.valueWidth
            text: SystemProvider.userName
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
            elide: Text.ElideRight
        }

        Item { Layout.preferredWidth: infoGrid.spacerWidth }

        Text {
            Layout.preferredWidth: infoGrid.labelWidth
            text: "HOST"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        Text {
            text: SystemProvider.hostName
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        // CPU

        Text {
            Layout.preferredWidth: infoGrid.labelWidth
            text: "CPU"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        Text {
            Layout.preferredWidth: infoGrid.valueWidth
            text: SystemProvider.cpuModel
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
            elide: Text.ElideRight
        }

        Item { Layout.preferredWidth: infoGrid.spacerWidth }

        Text {
            Layout.preferredWidth: infoGrid.labelWidth
            text: "GPU"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        Text {
            text: SystemProvider.gpuModel
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
            elide: Text.ElideRight
        }

        // UPTIME

        Text {
            Layout.preferredWidth: infoGrid.labelWidth
            text: "UP"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        Text {
            Layout.preferredWidth: infoGrid.valueWidth
            text: SystemProvider.uptime
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        Item { Layout.preferredWidth: infoGrid.spacerWidth }

        Text {
            Layout.preferredWidth: infoGrid.labelWidth
            text: "KERN"
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

        Text {
            text: SystemProvider.kernel
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.normalSize
        }

    }

}
