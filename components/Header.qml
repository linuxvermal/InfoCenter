import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell

import "../theme"

Item {

    id: root

    SystemClock {

        id: clock

        precision: SystemClock.Minutes

    }

    implicitWidth: parent ? parent.width : Theme.panelWidth
    implicitHeight: 38

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
        // DATE
        //

        Text {

            text: root.currentDate

            color: Theme.warning

            font.family: Theme.font

            font.pixelSize: Theme.headerDateSize

            horizontalAlignment: Text.AlignRight

            verticalAlignment: Text.AlignTop

            Layout.alignment: Qt.AlignTop | Qt.AlignRight

        }

    }

}
