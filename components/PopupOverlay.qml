import QtQuick

import Quickshell
import Quickshell.Wayland

import "../theme"
import "../providers"

Scope {

    Variants {

        model: Quickshell.screens

        PanelWindow {

            required property var modelData

            screen: modelData

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.namespace: "infocenter-popup"

            anchors {
                top: true
                left: true
            }

            margins {
                top: 24
                left: 24
            }

            exclusionMode: ExclusionMode.Ignore

            color: "transparent"

            implicitWidth: Theme.panelWidth
            implicitHeight: popupColumn.implicitHeight + 48


            Column {

                id: popupColumn

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right

                    topMargin: 24
                    leftMargin: 24
                    rightMargin: 24
                }

                spacing: 12

                Repeater {

                    model: PopupManager.activeNotifications

                    delegate: NotificationCard {

                        width: Theme.panelWidth - 48

                        popupMode: true

                        notification: modelData.notification

                    }

                }

            }

        }

    }

}
