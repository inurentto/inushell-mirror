import Quickshell.Widgets
import QtQuick

import qs.services



IconImage {
    id: root

    property color color: "white"

    source: ""

    implicitSize: 16

    layer.enabled: true
    layer.effect: ShaderEffect {
        property color color: root.color
        fragmentShader: "../shaders/ColoredIcon.frag.qsb"
        blending: true
    }
}