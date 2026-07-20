import QtQuick
import "../theme"

Rectangle {

    id: root

    property color dividerColor: Theme.separator

    width: parent ? parent.width : 0

    height: 1

    color: Theme.separator

}
