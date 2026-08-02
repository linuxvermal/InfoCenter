import QtQuick
import "../theme"

Row {

    id: root

    width: parent ? parent.width : 0

    spacing: Theme.spacing


    property string title: ""

    property string subtitle: ""


    property bool showSeparator: true



    Text {

        text: root.title

        color: Theme.accent

        font.family: Theme.font

        font.pixelSize: Theme.sectionTitleSize

        font.bold: true

        verticalAlignment: Text.AlignVCenter

    }



    Divider {

        visible: root.showSeparator

        width: root.width - titleText.width - Theme.spacing

        anchors.verticalCenter: parent.verticalCenter

        dividerColor: Theme.separator

    }


    // hidden helper so Divider knows the title width

    Text {

        id: titleText

        visible: false

        text: root.title

        font.family: Theme.font

        font.pixelSize: Theme.sectionTitleSize

        font.bold: true

    }

}
