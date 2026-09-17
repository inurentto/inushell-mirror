import QtQuick

import qs.services
import qs.singletons



Text {
    font.family: Settings.fonts.main
    font.pointSize: Settings.fontSize.normal

    renderType: Text.NativeRendering
    renderTypeQuality: Text.VeryHighRenderTypeQuality

    antialiasing: true

    color: Settings.palette.foreground0
}