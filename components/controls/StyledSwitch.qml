import QtQuick
import QtQuick.Controls

import qs.services
import qs.singletons
import qs.components
import qs.components.controls



StyledAbstractButton {
    id: root

    readonly property real knobPosition: checked ? 1 : 0
    property real visualKnobPosition: knobPosition
    property real draggingThreshold: 2
    property real _dragStart: -1
    property bool _dragging: false

    property alias text: label.text

    property color gutterColor: Settings.palette.background1
    property color gutterCheckedColor: Settings.palette.accent

    property color knobColor: Settings.palette.foreground0
    property color knobHoverColor: Settings.palette.foreground1
    property color knobDownColor: Settings.palette.accent

    property color knobFilledColor: Settings.palette.background1
    property color knobFilledHoverColor: Settings.palette.background2
    property color knobFilledDownColor: Settings.palette.background0

    // Math might be a bit incorrect somewhere? Seems like the knob is shifted left like 2 pixels
    function getKnobPositionFromMousePosition(mousePosition: real): real {
        const adjustedGutterWidth = gutter.width - gutter.height
        const adjustedMousePosition = mousePosition - knob.width / 2 - gutter.height / 4

        return Util.clamp(adjustedMousePosition / adjustedGutterWidth, 0, 1)
    }

    opacity: !enabled ? 0.5 : 1

    contentItem: Row {
        spacing: Settings.spacing.medium

        Rectangle {
            id: gutter

            x: y
            y: (parent.height - height) / 2
            implicitWidth: height * 2
            implicitHeight: 24

            color: checked ? gutterCheckedColor : gutterColor
            radius: Math.max(width / 2, height / 2)

            Rectangle {
                id: knob

                readonly property real knobSize: Math.min(parent.width - Settings.spacing.small * 2, parent.height - Settings.spacing.small * 2)
                property real knobSizeOffset: down ? knobSize / 8 : 0
                readonly property real visualKnobSize: knobSize - knobSizeOffset

                x: y + (parent.width - visualKnobSize - y * 2) * visualKnobPosition
                y: (parent.height - height) / 2
                implicitWidth: visualKnobSize
                implicitHeight: visualKnobSize

                color: {
                    if (enabled) {
                        if (checked) {
                            if (down) return knobFilledDownColor
                            else if (hovered) return knobFilledHoverColor
                            return knobFilledColor
                        } else {
                            if (down) return knobDownColor
                            else if (hovered) return knobHoverColor
                            return knobColor
                        }
                    } else {
                        if (checked) return knobFilledColor
                        return knobColor
                    }
                }
                radius: Math.max(width / 2, height / 2)

                Behavior on knobSizeOffset {
                    PropertyAnimation {
                        duration: Settings.animationSpeed.normal
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.normal
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: Settings.animationSpeed.normal
                    easing.type: Settings.animationEasing.easeOut
                }
            }
        }

        StyledText {
            id: label
            visible: text !== ""

            text: ""

            font: root.font
        }
    }

    Behavior on visualKnobPosition {
        PropertyAnimation {
            duration: Settings.animationSpeed.normal
            easing.type: Settings.animationEasing.easeOut
        }
    }
    Behavior on opacity {
        PropertyAnimation {
            duration: Settings.animationSpeed.normal
            easing.type: Settings.animationEasing.easeOut
        }
    }

    onClicked: (mouse) => {
        if (!_dragging) setChecked(!checked)
    }

    onPressed: (mouse) => {
        _dragging = false
        _dragStart = mouse.x
    }
    onReleased: (mouse) => {
        if (_dragging) setChecked(getKnobPositionFromMousePosition(mouse.x) > 0.5)
        visualKnobPosition = Qt.binding(() => knobPosition)
    }
    onPositionChanged: (mouse) => {
        if (pressing) {
            if (Math.abs(_dragStart - mouse.x) >= draggingThreshold) _dragging = true
            if (_dragging) visualKnobPosition = getKnobPositionFromMousePosition(mouse.x)
        }
    }

    onWheel: (wheel) => {
        if (wheelEnabled) root.wheel(wheel)
        else wheel.accepted = true
    }
}