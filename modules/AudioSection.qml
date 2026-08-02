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

        title: "AUDIO"

    }


    //
    // Volume + Output Device
    //

    RowLayout {

        width: parent.width

        spacing: 8


        StatMeter {

            Layout.fillWidth: true

            label: "VOL"

            value: AudioProvider.volume

            adaptiveColor: false

        }


        Text {

            text: AudioProvider.outputName

            color: Theme.warning

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

    }


    //
    // Mute Status
    //

    Row {

        spacing: 10


        Text {

            width: 48

            text: "MUTE"

            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }


        Text {

            text: AudioProvider.muted
                ? "Yes"
                : "No"


            color: Theme.text

            font.family: Theme.font

            font.pixelSize: Theme.normalSize

        }

    }


    Item {

        height: 4

    }


    //
    // Controls
    //

    Row {

        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 10


        ActionButton {

            text: "-"

            onClicked:

                AudioProvider.volumeDown()

        }


        ActionButton {

            text: "MUTE"

            active: AudioProvider.muted

            onClicked:

                AudioProvider.toggleMute()

        }


        ActionButton {

            text: "+"

            onClicked:

                AudioProvider.volumeUp()

        }

    }

}
