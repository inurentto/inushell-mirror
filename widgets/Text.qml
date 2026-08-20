import QtQuick

import qs.singletons



Text {
    font.family: Config.theme.mainFont
    font.pointSize: Config.theme.textSize.normal
    font.bold: false

    renderType: Text.NativeRendering
    renderTypeQuality: Text.VeryHighRenderTypeQuality

    antialiasing: true

    color: Config.theme.getForeground0()
}