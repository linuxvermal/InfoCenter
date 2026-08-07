import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell

import "../theme"
import "../providers"

Item {

    id: root

    WeatherProvider {

    id: weather

    }

    SystemClock {

        id: clock

        precision: SystemClock.Minutes

    }

    implicitWidth: parent ? parent.width : Theme.panelWidth
    implicitHeight: 56

    property string currentTime: ""
    property string currentDate: ""

    function updateClock() {

        currentTime =
            Qt.formatTime(clock.date, "h:mm AP")

        currentDate =
            Qt.formatDate(clock.date, "ddd - MMM d, yyyy")

    }

    Timer {

        interval: 60000

        running: true

        repeat: true

        triggeredOnStart: true

        onTriggered: root.updateClock()

    }

    RowLayout {

        anchors.fill: parent

        anchors.leftMargin: Theme.spacingSmall
        anchors.rightMargin: Theme.spacingSmall

        spacing: 0

        //
        // CLOCK
        //

        Text {

            text: root.currentTime

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.headerTimeSize

            font.bold: true

            Layout.alignment: Qt.AlignTop

        }

        Item {

            Layout.fillWidth: true

        }

         //
        // WEATHER + DATE
        //

        ColumnLayout {

            spacing: 2

            Layout.alignment: Qt.AlignTop | Qt.AlignRight

            RowLayout {

            spacing: 6

            Layout.alignment: Qt.AlignRight

            Text {

                text: weather.icon

                color: Theme.text

                font.family: "Noto Color Emoji"

                font.pixelSize: 26

                horizontalAlignment: Text.AlignRight

                Layout.alignment: Qt.AlignVCenter

            }

            Text {

                text: weather.temperatureText

                color: Theme.text

                font.family: Theme.font

                font.pixelSize: Theme.headerDateSize

                font.bold: true

                horizontalAlignment: Text.AlignRight

                Layout.alignment: Qt.AlignVCenter

        }

    }

    Text {

       text: weather.condition

       color: Theme.muted

       font.family: Theme.font

       font.pixelSize: Theme.weatherConditionSize

       horizontalAlignment: Text.AlignRight

       Layout.alignment: Qt.AlignRight

       }

    Text {

       text: root.currentDate

       color: Theme.warning

       font.family: Theme.font

       font.pixelSize: Theme.headerDateSize

       horizontalAlignment: Text.AlignRight

       Layout.alignment: Qt.AlignRight

       }

       }

    }

}
