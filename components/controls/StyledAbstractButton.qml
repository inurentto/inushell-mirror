import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.components



Control {
    id: root

    property bool _pressing: false
    readonly property bool pressing: _pressing
    property bool down: pressing

    property bool checked: false
    property StyledButtonGroup buttonGroup

    property alias acceptedButtons: mouseArea.acceptedButtons

    property bool groupedAndInSequence: {
        const inSequence = parent instanceof Row || parent instanceof RowLayout || parent instanceof Column || parent instanceof ColumnLayout
        return buttonGroup !== null && inSequence
    }
    property bool verticalSequence: {
        if (!groupedAndInSequence) return false
        return parent instanceof Column || parent instanceof ColumnLayout
    }
    property bool firstInSequence: {
        if (!groupedAndInSequence) return false
        return parent.children[0] === this
    }
    property bool lastInSequence: {
        if (!groupedAndInSequence) return false
        return parent.children[parent.children.length - 1] === this
    }

    signal clicked(mouse: MouseEvent)

    signal pressed(mouse: MouseEvent)
    signal released(mouse: MouseEvent)
    signal pressAndHold(mouse: MouseEvent)
    signal positionChanged(mouse: MouseEvent)

    signal wheel(wheel: WheelEvent)

    signal entered()
    signal exited()

    function setChecked(shouldBeChecked: bool): void {
        if (buttonGroup && buttonGroup.exclusive) {
            buttonGroup.setCheckedOnButtons(false)
            checked = true
        } else checked = shouldBeChecked

        if (buttonGroup) buttonGroup.updateCheckedButtons()
    }

    hoverEnabled: true

    opacity: !enabled ? 0.5 : 1
    clip: true

    font.family: Settings.fonts.main
    font.pointSize: Settings.fontSize.normal

    Component.onCompleted: () => {
        if (buttonGroup) {
            buttonGroup.buttons.append({ "button": this })
            buttonGroup.updateCheckedButtons()
        }
    }

    Behavior on opacity {
        PropertyAnimation {
            duration: Settings.animationSpeed.normal
            easing.type: Settings.animationEasing.easeOut
        }
    }

    MouseArea {
        id: mouseArea

        enabled: root.enabled

        anchors.fill: root
        cursorShape: Qt.PointingHandCursor

        hoverEnabled: root.hoverEnabled

        onClicked: (mouse) => root.clicked(mouse)

        onPressed: (mouse) => {
            _pressing = true
            root.pressed(mouse)
        }
        onReleased: (mouse) => {
            _pressing = false
            root.released(mouse)
        }
        onPressAndHold: (mouse) => root.pressAndHold(mouse)
        onPositionChanged: (mouse) => root.positionChanged(mouse)

        onWheel: (wheel) => {
            if (wheelEnabled) root.wheel(wheel)
            else wheel.accepted = true;
        }

        onEntered: () => root.entered()
        onExited: () => root.exited()
    }
}