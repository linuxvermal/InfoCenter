import QtQuick

FocusScope {

    id: root

    width: parent ? parent.width : 0
    height: childrenRect.height

    //
    // Is this keyboard region currently active?
    //

    readonly property bool active: activeFocus

    property FocusRegion tabForward: null
    property FocusRegion tabBackward: null

    //
    // Notify parent when this region becomes active.
    //
    signal activated()

    //
    // Notify parent when this region loses focus.
    //
    signal deactivated()

    Keys.onTabPressed: {

    if (!tabForward)
        return

        tabForward.activate()

        event.accepted = true

    }

    onActiveFocusChanged: {

        if (activeFocus)
            activated()
        else
            deactivated()

    }

    function activate() {

        forceActiveFocus()

    }

}
