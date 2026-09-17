import Quickshell.Widgets
import QtQuick



Item {
    id: root

    property color disabledModulation: Qt.rgba(1, 1, 1, 0.5);

    property alias enabled: mouseArea.enabled

    property alias acceptedButtons: mouseArea.acceptedButtons
    property alias cursorShape: mouseArea.cursorShape

    property alias hoverEnabled: mouseArea.hoverEnabled
    property bool wheelEnabled: false

    property alias hovered: mouseArea.containsMouse

    readonly property alias isHovered: mouseArea.containsMouse
    readonly property bool isPressed: mouseArea.pressed

    property alias propagateComposedEvents: mouseArea.propagateComposedEvents
    property alias scrollGestureEnabled: mouseArea.scrollGestureEnabled

    default property alias content: mouseArea.data
    
    property color _modulation: Qt.rgba(1, 1, 1, 1)
    readonly property color modulation: _modulation

    readonly property alias mouseX: mouseArea.mouseX
    readonly property alias mouseY: mouseArea.mouseY

    signal pressed(MouseEvent mouse)
    signal released(MouseEvent mouse)
    signal clicked(MouseEvent mouse)
    signal wheel(WheelEvent wheel)
    signal positionChanged(MouseEvent mouse)
    signal entered()
    signal exited()

    implicitWidth: mouseArea.width
    implicitHeight: mouseArea.height
    
    WrapperMouseArea {
        id: mouseArea

        hoverEnabled: true
        cursorShape: mouseArea.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        acceptedButtons: Qt.LeftButton

        onPressed: (mouse) => root.pressed(mouse)
        onReleased: (mouse) => root.released(mouse)
        onClicked: (mouse) => root.clicked(mouse)
        onWheel: (wheel) => { if (wheelEnabled) root.wheel(wheel); else wheel.accepted = false }
        onPositionChanged: (mouse) => root.positionChanged(mouse)
        onEntered: () => root.entered()
        onExited: () => root.exited()
    }
}