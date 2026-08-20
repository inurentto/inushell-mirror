import QtQuick

import qs.singletons



QtObject {
    property string name: ""
    property bool enabled: true

    property int acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    property int cursorShape: acceptedButtons === Qt.NoButton ? Qt.ArrowCursor : Qt.PointingHandCursor

    property real topPadding: 4
    property real bottomPadding: 4
    property real leftPadding: 8
    property real rightPadding: 8

    property real aspectRatio

    property color backgroundColor: Config.theme.getBackground1( )
    property color backgroundHoverColor: Config.theme.getBackground2( )
    property color backgroundPressColor: Config.theme.getBackground0( )
    property color borderColor: Config.theme.getBackground2( )
    property color borderHoverColor: Config.theme.getBorder( )
    property color borderPressColor: Config.theme.getAccent( )

    default property Item content
}