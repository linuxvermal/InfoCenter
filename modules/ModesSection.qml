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
        title: "MODES"
    }

    Item {
        width: 1
        height: 2
    }

    Row {

        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 10

        ActionButton {

            text: "PEACE"

            active: ModesProvider.peaceEnabled

            onClicked: ModesProvider.togglePeace()

        }

        ActionButton {

            text: "NIGHT"

            active: ModesProvider.nightEnabled

            onClicked: ModesProvider.toggleNight()

        }

    }

}
