import Quickshell.Widgets
import QtQuick.Effects

import qs.singletons

IconImage {
    property alias tint: effect.colorizationColor

    implicitSize: 16

    MultiEffect {
        id: effect

        anchors.fill: parent
        source: parent.backer
        colorization: 1
        colorizationColor: Config.theme.getForeground0( )
    }
}