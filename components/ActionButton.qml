import QtQuick
import "../theme"


Rectangle {

    id: root

    focus: true

    property string text: ""

    property bool active: false


    signal clicked()


    width: 55

    height: 24

    radius: 4



    color: {

        if (root.active)

            return Theme.accent


        if (mouse.containsMouse)

            return Theme.separator


        return "transparent"

    }


    border.color: activeFocus
              ? Theme.warning
              : Theme.separator

    border.width: 1



    Text {

        anchors.centerIn: parent


        text: root.text


        color: root.active
            ? Theme.dark
            : Theme.text


        font.family: Theme.font

        font.pixelSize: Theme.normalSize

        font.bold: true

    }

    Keys.onReturnPressed: root.clicked()

    Keys.onEnterPressed: root.clicked()

    Keys.onSpacePressed: root.clicked()


    MouseArea {

        id: mouse


        anchors.fill: parent


        hoverEnabled: true



        onClicked: {

            root.clicked()

        }

    }

}
