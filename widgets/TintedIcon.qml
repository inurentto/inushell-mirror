import Quickshell.Widgets
import QtQuick.Effects

import qs.services
import qs.singletons



IconImage {
    property alias tint: effect.colorizationColor
    property bool brighten: false

    implicitSize: 16

    MultiEffect {
        id: effect

        anchors.fill: parent
        source: parent.backer
        brightness: brighten ? 0.65 : 0
        colorization: 1
        colorizationColor: Settings.palette.foreground0
    }
}