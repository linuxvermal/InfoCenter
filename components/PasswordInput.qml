import QtQuick

import "../theme"

Rectangle {

    id: root

    focus: true

    onActiveFocusChanged: {

      if (activeFocus)
        input.forceActiveFocus()

    }

    property string text: ""
    property bool authenticationFailed: false

    function forceFocus() {

    input.forceActiveFocus()

    }

    width: 220
    height: 28
    radius: 4

    color: "transparent"

    border.width: 1
    border.color: authenticationFailed
                  ? Theme.critical
                  : Theme.separator

    TextInput {

        id: input

        focus: false

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: 8
            rightMargin: 8
        }

        text: root.text

        color: Theme.text

        font.family: Theme.font
        font.pixelSize: Theme.normalSize

        echoMode: TextInput.Password

        selectByMouse: false

        onTextChanged: {

            root.text = text

        }
    }
}
