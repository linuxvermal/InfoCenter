import QtQuick
import QtQuick.Controls

import "../theme"
import "../components"
import "../providers"

Column {

    id: root

    width: parent ? parent.width : 0

    spacing: Theme.sectionSpacing

    //
    // Height of the notification viewport.
    // Tuned to display approximately four cards.
    //

    readonly property int viewportHeight: 420

    //----------------------------------------------------------------------
    // Header
    //----------------------------------------------------------------------

    SectionTitle {
        title: "NOTIFICATIONS"
    }

    //----------------------------------------------------------------------
    // Empty State
    //----------------------------------------------------------------------

    Text {

        visible: NotificationProvider.notifications.length === 0

        width: parent.width

        text: "No notifications"

        color: Theme.muted

        font.family: Theme.font
        font.pixelSize: Theme.normalSize

        horizontalAlignment: Text.AlignHCenter
    }

    //----------------------------------------------------------------------
    // Notification History
    //----------------------------------------------------------------------

    ScrollView {

        visible: NotificationProvider.notifications.length > 0

        width: parent.width

        height: viewportHeight

        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        Column {

            width: root.width - 8

            spacing: Theme.spacingSmall

            Repeater {

                model: NotificationProvider.notifications

                delegate: NotificationCard {

                    width: parent.width

                    notification: modelData

                }

            }

        }

    }

}
