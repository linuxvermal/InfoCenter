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
        title: "BATTERY"
    }

    //
    // Battery Meter + Active Profile
    //

    RowLayout {

        width: parent.width

        spacing: 8

        StatMeter {

            Layout.fillWidth: true

            label: "BAT"

            value: BatteryProvider.percent / 100.0

            adaptiveColor: true

            state: BatteryProvider.state

        }

        Text {

            text: PowerProvider.profile

            color: Theme.warning

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

            font.bold: false

        }

    }

    Item {
        height: 4
    }

    //
    // Battery Information
    //

    GridLayout {

        id: infoGrid

        width: parent.width

        columns: 5

        columnSpacing: 10

        rowSpacing: 6

        property int labelWidth: 48
        property int valueWidth: 86
        property int spacerWidth: 20

        Text {

            Layout.preferredWidth: infoGrid.labelWidth

            text: "STATE"

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

        Text {

            Layout.preferredWidth: infoGrid.valueWidth

            text: BatteryProvider.state

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

        Item {
            Layout.preferredWidth: infoGrid.spacerWidth
        }

        Text {

            Layout.preferredWidth: infoGrid.labelWidth

            text: "TIME"

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

        Text {

            text: BatteryProvider.timeRemaining

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

        Text {

            Layout.preferredWidth: infoGrid.labelWidth

            text: "HEALTH"

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

        Text {

            Layout.preferredWidth: infoGrid.valueWidth

            text: BatteryProvider.batteryHealth

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

        Item {
            Layout.preferredWidth: infoGrid.spacerWidth
        }

        Text {

            Layout.preferredWidth: infoGrid.labelWidth

            text: "CYCLES"

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

        Text {

            text: BatteryProvider.batteryCycles

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

    }

    Item {
        height: 8
    }

    //
    // Power Controls
    //

    Item {

    width: parent.width
    height: 28

    Row {
        
        anchors.centerIn: parent
        spacing: 8

        ActionButton {

            text: "PERF"

            active: PowerProvider.profile === "performance"

            onClicked: PowerProvider.setProfile("performance")

        }

        ActionButton {

            text: "BAL"

            active: PowerProvider.profile === "balanced"

            onClicked: PowerProvider.setProfile("balanced")

        }

        ActionButton {

            text: "SAVE"

            active: PowerProvider.profile === "power-saver"

            onClicked: PowerProvider.setProfile("power-saver")

        }

    }
  }
}
