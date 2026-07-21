import QtQuick
import Quickshell
import Quickshell.Io

import "core"
import "."

ShellRoot {
    id: shell

    property bool infoCenterVisible: false

    function toggleInfoCenter() {
        infoCenterVisible = !infoCenterVisible
    }

    InfoCenter {
        visible: shell.infoCenterVisible
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
