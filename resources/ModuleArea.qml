import Quickshell
import QtQuick

import qs.services
import qs.singletons
import qs.resources



QtObject {
    property string name: ""
    property bool enabled: true
    property bool visible: true

    property int acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    property int cursorShape: acceptedButtons === Qt.NoButton ? Qt.ArrowCursor : Qt.PointingHandCursor

    property real topPadding: 4
    property real bottomPadding: 4
    property real leftPadding: 8
    property real rightPadding: 8

    property real aspectRatio

    property color backgroundColor: Settings.palette.background1
    property color backgroundHoverColor: Settings.palette.background2
    property color backgroundPressColor: Settings.palette.background0
    property color borderColor: Settings.palette.background2
    property color borderHoverColor: Settings.palette.border
    property color borderPressColor: Settings.palette.accent

    property Component panelContent: null
    default property Item content

    required property QsWindow window

    signal opened()

    function getContentX(): real {
        return content.parent !== null ? content.parent.mapToItem(null, 0, 0).x : 0
    }
    function getContentWidth(): real {
        return content.parent !== null ? content.parent.width : 0
    }
}