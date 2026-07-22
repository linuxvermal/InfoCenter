import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell

import "components"
import "modules"
import "providers"
import "theme"

PanelWindow {

    id: root

    focusable: true

    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    Timer {
        interval: 1000
        running: true
        repeat: true
    }

    anchors {
        top: true
        right: true
        bottom: true
    }

    implicitWidth: Theme.panelWidth

    Rectangle {

        anchors.fill: parent

        color: Qt.rgba(0.07, 0.07, 0.11, 0.82)

        Flickable {

            id: flick

            anchors.fill: parent

            clip: true

            contentWidth: width
            contentHeight: contentColumn.height + 32

            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            Column {

                id: contentColumn

                width: flick.width - 32

                anchors.horizontalCenter: parent.horizontalCenter

                anchors.top: parent.top
                anchors.topMargin: 16

                spacing: 14

                Header { }

                ModesSection { }

                SystemSection {
                    width: parent.width
                }

                BatterySection {
                    width: parent.width
                }

                AudioSection {
                    width: parent.width
                }

                NetworkSection {
                    width: parent.width
                }

                NotificationSection {
                    width: parent.width
                }

                Item {
                    width: 1
                    height: 16
                }
            }
        }
    }
}
