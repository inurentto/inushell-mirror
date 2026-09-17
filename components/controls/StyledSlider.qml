import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

import qs.services
import qs.singletons
import qs.components.controls



Control {
    id: root

    property bool _pressing: false
    readonly property bool pressing: _pressing
    property bool down: pressing

    property bool vertical: false
    property bool flip: false

    property real minValue: 0
    property real maxValue: 1
    property real value: 0
    property real step: 0
    property real visualValue: (value - minValue) / (maxValue + minValue)

    property list<real> snapPoints: []
    property real snapThreshold: 0.05

    property real knobMargin: Settings.spacing.small
    property real knobLength: knobMargin * 2

    property real snapPointMargin: 2

    property bool filled: true

    property color gutterColor: Settings.palette.background1
    property color fillColor: Settings.palette.accent

    property color knobColor: Settings.palette.foreground0
    property color knobHoverColor: Settings.palette.foreground1
    property color knobDownColor: Settings.palette.accent

    property color knobFilledColor: Settings.palette.background1
    property color knobFilledHoverColor: Settings.palette.background2
    property color knobFilledDownColor: Settings.palette.background0

    property color snapPointColor: Settings.palette.foreground2
    property color snapPointSnappedColor: Settings.palette.background1
    property color snapPointFilledSnappedColor: Settings.palette.foreground0

    signal moved(value: real)

    signal clicked(mouse: MouseEvent)

    signal pressed(mouse: MouseEvent)
    signal released(mouse: MouseEvent)
    signal pressAndHold(mouse: MouseEvent)
    signal positionChanged(mouse: MouseEvent)

    signal wheel(wheel: WheelEvent)

    signal entered()
    signal exited()

    function positionToValue(position: real, snap: bool): real {
        const adjustedLength = contentItem.length - knobLength - knobMargin * 2
        const adjustedPosition = position - knobLength / 2 - knobMargin
        const rawValue = (flip ? (adjustedLength - adjustedPosition) : adjustedPosition) / adjustedLength
        const adjustedValue = rawValue * (maxValue - minValue) + minValue

        let snappedValue = adjustedValue
        if (snap) {
            let shortestSnapDistance = (maxValue - minValue) + minValue
            for (let index = 0; index < snapPoints.length; index++) {
                const snapPoint = snapPoints[index]
                const distance = adjustedValue - snapPoint
                if (Math.abs(distance) <= snapThreshold && Math.abs(distance) < shortestSnapDistance) {
                    snappedValue = snapPoint
                    shortestSnapDistance = Math.abs(distance)
                }
            }
        }

        const roundedValue = step > 0 ? Math.round(snappedValue / step) * step : snappedValue

        return Util.clamp(roundedValue, minValue, maxValue)
    }

    implicitWidth: vertical ? 24 : 200
    implicitHeight: vertical ? 200 : 24

    padding: 0

    hoverEnabled: true

    opacity: !enabled ? 0.5 : 1

    contentItem: Rectangle {
        readonly property real length: vertical ? height : width
        readonly property real thickness: vertical ? width : height

        readonly property real knobThickness: thickness - knobMargin * 2
        readonly property real visualPosition: knobLength + knobMargin * 2 + (length - knobLength - knobMargin * 2) * (flip ? 1 - visualValue : visualValue)

        color: gutterColor
        radius: Settings.radius.medium

        Rectangle {
            anchors.right: flip && !vertical ? parent.right : undefined
            anchors.bottom: flip && vertical ? parent.bottom : undefined

            readonly property real fillLength: flip ? contentItem.length - contentItem.visualPosition + knobLength + knobMargin * 2 : contentItem.visualPosition

            implicitWidth: vertical ? contentItem.thickness : fillLength
            implicitHeight: vertical ? fillLength : contentItem.thickness

            color: fillColor
            radius: contentItem.radius

            visible: filled
        }

        Rectangle {
            id: knob

            readonly property real knobPosition: contentItem.visualPosition - knobLength - knobMargin

            x: vertical ? knobMargin : knobPosition
            y: vertical ? knobPosition : knobMargin
            implicitWidth: vertical ? contentItem.knobThickness : knobLength
            implicitHeight: vertical ? knobLength : contentItem.knobThickness

            color: {
                if (enabled) {
                    if (filled) {
                        if (down) return knobFilledDownColor
                        else if (hovered) return knobFilledHoverColor
                        return knobFilledColor
                    } else {
                        if (down) return knobDownColor
                        else if (hovered) return knobHoverColor
                        return knobColor
                    }
                } else {
                    if (filled) return knobFilledColor
                    return knobColor
                }
            }
            radius: Settings.radius.small
        }

        Repeater {
            model: snapPoints

            Rectangle {
                required property real modelData

                readonly property real snapped: modelData === value

                readonly property real snapPointLength: knobLength - snapPointMargin * 2
                property real snapPointThickness: snapped ? root.contentItem.knobThickness - snapPointMargin * 2 : snapPointLength

                readonly property real snapPointVisualValue: (modelData - minValue) / (maxValue + minValue)
                readonly property real snapPointPosition: knobMargin + snapPointMargin + (contentItem.length - knobLength - knobMargin * 2) * (flip ? 1 - snapPointVisualValue : snapPointVisualValue)

                x: vertical ? contentItem.thickness / 2 - width / 2 : snapPointPosition
                y: vertical ? snapPointPosition : contentItem.thickness / 2 - height / 2
                implicitWidth: vertical ? snapPointThickness : snapPointLength
                implicitHeight: vertical ? snapPointLength : snapPointThickness

                color: snapped ? (filled ? snapPointFilledSnappedColor : snapPointSnappedColor) : snapPointColor
                radius: Settings.radius.big

                Behavior on snapPointThickness {
                    PropertyAnimation {
                        duration: Settings.animationSpeed.slow
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.slow
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
            }
        }
    }

    Behavior on visualValue {
        PropertyAnimation {
            duration: Settings.animationSpeed.fast
            easing.type: Settings.animationEasing.easeOut
        }
    }

    MouseArea {
        id: mouseArea

        enabled: root.enabled

        anchors.fill: root
        cursorShape: vertical ? Qt.SizeVerCursor : Qt.SizeHorCursor

        hoverEnabled: root.hoverEnabled

        onClicked: (mouse) => root.clicked(mouse)

        onPressed: (mouse) => {
            _pressing = true
            if (vertical) root.moved(positionToValue(mouseY, mouse.modifiers !== Qt.ControlModifier))
            else root.moved(positionToValue(mouseX, mouse.modifiers !== Qt.ControlModifier))
            root.pressed(mouse)
        }
        onReleased: (mouse) => {
            _pressing = false
            root.released(mouse)
        }
        onPressAndHold: (mouse) => root.pressAndHold(mouse)
        onPositionChanged: (mouse) => {
            if (pressing) {
                if (vertical) root.moved(positionToValue(mouseY, mouse.modifiers !== Qt.ControlModifier))
                else root.moved(positionToValue(mouseX, mouse.modifiers !== Qt.ControlModifier))
            }
            root.positionChanged(mouse)
        }

        onWheel: (wheel) => {
            if (wheelEnabled) root.wheel(wheel)
            else wheel.accepted = true;
        }

        onEntered: () => root.entered()
        onExited: () => root.exited()
    }
}