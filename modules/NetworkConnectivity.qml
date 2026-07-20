import QtQuick
import QtQuick.Layouts

import "../theme"
import "../components"
import "../providers"

Column {
    id: root

    focus: true

    width: parent ? parent.width : 0
    spacing: 8

    property string selectedNetwork: ""
    property bool selectedSecure: false

    property int selectedIndex: -1

    property bool connecting: false
    property bool authenticationFailed: false

    readonly property int focusList: 0
    readonly property int focusButtons: 1

    property int focusMode: focusList

    function setFocusMode(mode) {

    if (focusMode === mode)
        return

          focusMode = mode

    }

    function selectNetwork(index) {

          let network = NetworkProvider.availableNetworks[index]

        if (!network)
          return

          root.selectedIndex = index
          root.selectedNetwork = network.ssid
          root.selectedSecure = network.secure

          root.connecting = false
          root.authenticationFailed = false

          passwordBox.text = ""

        if (network.secure)
          passwordBox.forceFocus()

    }

    function connectSelectedNetwork() {

          root.connecting = true

          NetworkProvider.connect(
            root.selectedNetwork,
            passwordBox.text
          )

    }

    function resetPopupState() {

    //
    // Default to the connected network
    // (always first in the list).
    //
          root.selectedIndex = -1

          root.selectedNetwork = ""
          root.selectedSecure = false

          root.connecting = false
          root.authenticationFailed = false

          passwordBox.text = ""

    }

    signal connectionSucceeded()
    signal cancelRequested()

    Text {
        text: "AVAILABLE WIFI"
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.normalSize
    }

    Flickable {

        id: networkList

        onActiveFocusChanged: {

          if (activeFocus)
              root.setFocusMode(root.focusList)

        }

        focus: true

        width: parent.width
        height: 182
        clip: true
        contentHeight: listColumn.height

        Column {
            id: listColumn
            width: parent.width
            spacing: 4

            Repeater {
                model: NetworkProvider.availableNetworks

                delegate: WifiNetworkRow {

                    width: listColumn.width

                    networkName: modelData.ssid
                    signalStrength: modelData.signal
                    secure: modelData.secure
                    connected: modelData.connected

                    authenticationFailed: root.authenticationFailed

                    selected:
                        root.focusMode === root.focusList &&
                        (
                          root.selectedIndex >= 0
                            ? index === root.selectedIndex
                              : (
                                root.selectedNetwork !== ""
                                  ? root.selectedNetwork === modelData.ssid
                                  : modelData.connected
                                )
                        )

            onClicked: {

                  if (root.authenticationFailed)
                      return

                      root.selectNetwork(index)

                  }            

                }
            }
        }
    }

    PasswordInput {

          id: passwordBox

          visible:
              root.selectedNetwork !== "" &&
              root.selectedSecure

          authenticationFailed:
              root.authenticationFailed

    }

          KeyNavigation.tab: connectButton
          KeyNavigation.backtab: cancelButton

    //
    // NEW SCAN/CANCEL ROW
    //

    Row {

        visible: root.selectedNetwork === ""

        spacing: 6

    ActionButton {

            id: popupScanButton

            KeyNavigation.tab: popupCancelButton
            KeyNavigation.backtab: networkList

            onActiveFocusChanged: {

                if (!activeFocus)
                  return

                  root.setFocusMode(root.focusButtons)

            }

            width: 110

            enabled: !NetworkProvider.scanning

            text: NetworkProvider.scanning
                   ? "SCANNING..."
                   : "SCAN"

            onClicked: {

                NetworkProvider.availableNetworks = []

                //
                // Default to the first (connected) network.
                //
                connectivity.selectedIndex = 0

                NetworkProvider.scan()

            }

        }

    ActionButton {

            id: popupCancelButton

            KeyNavigation.tab: networkList
            KeyNavigation.backtab: popupScanButton

            text: "CANCEL"

            onActiveFocusChanged: {

                if (!activeFocus)
                return

                root.setFocusMode(root.focusButtons)

            }

            onClicked: {

                root.resetPopupState()

                root.cancelRequested()

            }

        }

    }


    //
    // CONNECT/CANCEL ROW
    //

    Row {
        visible: root.selectedNetwork !== ""
        spacing: 6


    ActionButton {

        id: connectButton

        KeyNavigation.tab: cancelButton
        KeyNavigation.backtab: passwordBox

        width: 110

        enabled: !root.connecting

        text: {

          if (root.connecting)
            return "CONNECTING..."

          if (root.authenticationFailed)
            return "RETRY"

            return "CONNECT"
    }

    onClicked: {

        root.connectSelectedNetwork()

    }
}

    ActionButton {

        id: cancelButton

        KeyNavigation.backtab: connectButton
        KeyNavigation.tab: passwordBox

        text: "CANCEL"

    onClicked: {

        root.resetPopupState()

        root.cancelRequested()
            }
        }
}

    Connections {

           target: NetworkProvider

           function onConnectionSucceeded() {
                
               root.resetPopupState()

               root.connectionSucceeded()

           }

           function onConnectionFailed() {

               root.connecting = false

               root.authenticationFailed = true
               passwordBox.text = ""

             Qt.callLater(function() {
               passwordBox.forceFocus()
          })

       }

          function onScanFinished() {

            if (NetworkProvider.availableNetworks.length > 0)
                root.selectedIndex = 0

       }

    }

          Component.onCompleted: forceActiveFocus()


          Keys.onEscapePressed: {

              root.resetPopupState()

              root.cancelRequested()

          }


          Keys.onPressed: function(event) {

            if (NetworkProvider.availableNetworks.length === 0)
                return

    //
    // During authentication failure, lock navigation
    // but continue to allow Enter, Esc and future Tab.
    //
            if (root.authenticationFailed &&
               (event.key === Qt.Key_Up ||
                event.key === Qt.Key_Down)) {

                event.accepted = true
                return

            }

            if (event.key === Qt.Key_Tab &&
               !(event.modifiers & Qt.ShiftModifier) &&
                root.selectedNetwork === "") {

                popupScanButton.forceActiveFocus()

                event.accepted = true
                return

            }

            if (event.key === Qt.Key_Down) {

                  root.selectedIndex = Math.min(
                  root.selectedIndex + 1,
                  NetworkProvider.availableNetworks.length - 1
                  )

                  let rowHeight = 30
                  let y = root.selectedIndex * rowHeight

            if (y + rowHeight > networkList.contentY + networkList.height)
                  networkList.contentY = y + rowHeight - networkList.height

                  event.accepted = true
            }

            if (event.key === Qt.Key_Up) {

                  root.selectedIndex = Math.max(
                  root.selectedIndex - 1,
                  0
                  )

                  let rowHeight = 30
                  let y = root.selectedIndex * rowHeight

            if (y < networkList.contentY)
                  networkList.contentY = y

                  event.accepted = true
            }

            if (event.key === Qt.Key_Home) {

                  root.selectedIndex = 0

                  networkList.contentY = 0

                  event.accepted = true
            }

            if (event.key === Qt.Key_End) {

                  root.selectedIndex =
                  NetworkProvider.availableNetworks.length - 1

                  let rowHeight = 30

                  networkList.contentY = Math.max(
                  0,
                  networkList.contentHeight - networkList.height
                  )

                  event.accepted = true
            }

            if (event.key === Qt.Key_Return ||
                  event.key === Qt.Key_Enter) {

    //
    // Password visible?
    // Then CONNECT / RETRY.
    //
            if (passwordBox.visible) {

                root.connectSelectedNetwork()

            }
    //
    // Otherwise we're browsing.
    //
            else if (root.selectedIndex >= 0) {

                root.selectNetwork(root.selectedIndex)

            }

                event.accepted = true
            }

     }

}
