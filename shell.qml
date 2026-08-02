import QtQuick
import Quickshell
import Quickshell.Io

import "core"
import "components"
import "controllers"
import "."

ShellRoot {
    id: shell

    property bool infoCenterVisible: false

//
// Global Alert Controller
//
// Lives for the lifetime of the Quickshell session.
// Evaluates battery policy and forwards notifications
// to AlertManager.
//
AlertController {
    }

    function toggleInfoCenter() {
        infoCenterVisible = !infoCenterVisible
    }

    InfoCenter {
        visible: shell.infoCenterVisible
    }

    PopupOverlay {
    }

    IpcHandler {
        target: "infocenter"

        function toggle(): void {
            shell.toggleInfoCenter()
        }

        function show(): void {
            shell.infoCenterVisible = true
        }

        function hide(): void {
            shell.infoCenterVisible = false
        }
    }
}
