import QtQuick
import QtQuick.Layouts

import "../theme"
import "../providers"

Rectangle {

    id: root

    property bool popupMode: false

    //----------------------------------------------------------------------
    // Input
    //----------------------------------------------------------------------

    property var notification

    //----------------------------------------------------------------------
    // Derived Properties
    //----------------------------------------------------------------------

    readonly property string appName:
        notification?.appName ?? ""

    readonly property string summary:
        notification?.summary ?? ""

    readonly property string body:
        notification?.body ?? ""

    readonly property string urgency:
        notification?.urgency ?? "normal"

    readonly property double timestamp:
        notification?.timestamp ?? 0

    readonly property int count:
        notification?.count ?? 1

    readonly property color urgencyColor: {

        switch (urgency) {

        case "low":
            return Theme.noncritical

        case "warning":
            return Theme.warning

        case "critical":
            return Theme.critical

        default:
            return Theme.text
        }
    }

    readonly property string timeString: {

        if (!timestamp)
            return ""

        return Qt.formatTime(
            new Date(timestamp),
            "h:mm AP"
        )
    }

    //----------------------------------------------------------------------
    // Geometry
    //----------------------------------------------------------------------

    implicitWidth: Theme.panelWidth - (Theme.spacing * 2)

    implicitHeight:
        layout.implicitHeight +
        (Theme.spacing * 2)

    //----------------------------------------------------------------------
    // Appearance
    //----------------------------------------------------------------------

    color: popupMode
       ? Qt.rgba(0.10, 0.09, 0.08, 0.82)
       : Theme.background

    radius: Theme.radius

    border.color: Theme.separator
    border.width: 1

    //----------------------------------------------------------------------
    // Layout
    //----------------------------------------------------------------------

    ColumnLayout {

        id: layout

        anchors.fill: parent
        anchors.margins: Theme.spacing

        spacing: Theme.spacingSmall

        //------------------------------------------------------------------
        // Header
        //------------------------------------------------------------------

        RowLayout {

            Layout.fillWidth: true

            Text {

                Layout.fillWidth: true

                text: appName

                color: Theme.text

                font.family: Theme.font
                font.pixelSize: Theme.titleSize

                elide: Text.ElideRight
            }

            Text {

                visible: count > 1

                text: "(" + count + ")"

                color: Theme.notificationcount

                font.family: Theme.font
                font.pixelSize: 14
            }

            Item {

                visible: count > 1

                width: Theme.spacingSmall
                height: 1
            }

            Rectangle {

                width: 8
                height: 8

                radius: 4

                color: urgencyColor
            }

            Item {

                width: Theme.spacingSmall
                height: 1
            }

            Text {

                text: "×"

                color: Theme.muted

                font.family: Theme.font
                font.pixelSize: 24
                font.bold: true

                verticalAlignment: Text.AlignVCenter

                MouseArea {

                    anchors.fill: parent

                    onClicked: {

                        NotificationProvider.removeNotification(
                            notification.id
                        )

                    }

                }

            }

        }

        //------------------------------------------------------------------
        // Summary
        //----------------------------------------------------------------------

        Text {

            Layout.fillWidth: true

            visible: summary.length > 0

            text: summary

            color: Theme.text

            font.family: Theme.font
            font.pixelSize: Theme.normalSize

            wrapMode: Text.WordWrap
        }

        //------------------------------------------------------------------
        // Body
        //----------------------------------------------------------------------

        Text {

            Layout.fillWidth: true

            visible: body.length > 0

            text: body

            color: Theme.muted

            font.family: Theme.font
            font.pixelSize: Theme.normalSize

            wrapMode: Text.WordWrap
        }

        //------------------------------------------------------------------
        // Timestamp
        //----------------------------------------------------------------------

        Text {

            Layout.fillWidth: true

            visible: timeString.length > 0

            horizontalAlignment: Text.AlignRight

            text: timeString

            color: Theme.muted

            font.family: Theme.font
            font.pixelSize: Theme.smallSize
        }
    }
}
