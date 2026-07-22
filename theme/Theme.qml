pragma Singleton

import QtQuick

QtObject {

    //
    // Colors
    //

    property color background:
        Qt.rgba(0.10, 0.09, 0.08, 0.88)

    property color panel:
        Qt.rgba(0.07, 0.07, 0.11, 0.82)

    property color dark:
        "#282828"

    property color text:
        "#e8e6d9"

    property color muted:
        "#a89984"

    property color accent:
        "#89b4c2"

    property color bar:
        "#e8e6d9"

    property color notificationcount:
        "#c8a2c8"

    //
    // Dividers
    //

    property color separator:
        "#3a3732"

    property color headerSeparator:
        "#4a4540"

    //
    // Status Colors
    //

    property color noncritical:
        "#98c379"

    property color warning:
        "#e5c07b"

    property color critical:
        "#e06c75"

    //
    // Typography
    //

    property string font:
        "JetBrainsMono Nerd Font"

    property int headerTimeSize:
        28

    property int headerDateSize:
        14

    property int sectionTitleSize:
        13

    property int titleSize:
        13

    property int normalSize:
        12

    property int smallSize:
        10

    //
    // Spacing
    //

    property int spacingSmall:
        4

    property int spacing:
        8

    property int spacingLarge:
        16

    property int sectionSpacing:
        4

    property int panelPadding:
        12

    //
    // Layout
    //

    property int panelWidth:
        408 

    property int headerHeight:
        54

    property int radius:
        6

    property int infoLabelWidth:
        58
}
