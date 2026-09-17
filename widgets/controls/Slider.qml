import Quickshell.Widgets
import QtQuick

import qs.services
import qs.singletons
import qs.widgets



Control {
    id: root

    property color backgroundColor: Settings.palette.background1
    property color backgroundHoverColor: Settings.palette.background1
    property color backgroundPressColor: Settings.palette.background1
    property color backgroundBorderColor: Settings.palette.background2
    property color backgroundBorderHoverColor: Settings.palette.border
    property color backgroundBorderPressColor: Settings.palette.border

    property color knobColor: filled ? Settings.palette.background1 : Settings.palette.foreground0
    property color knobHoverColor: filled ? Settings.palette.background2 : Settings.palette.foreground1
    property color knobPressColor: filled ? Settings.palette.background0 : Settings.palette.accent
    property color knobBorderColor: Settings.palette.foreground2
    property color knobBorderHoverColor: Settings.palette.foreground2
    property color knobBorderPressColor: Settings.palette.foreground2

    property color fillColor: Settings.palette.accent
    property color fillBorderColor: Settings.palette.foreground2

    property color snapColor: Settings.palette.foreground2
    property color snapActiveColor: filled ? Settings.palette.foreground0 : Settings.palette.background0

    property int borderWidth: 0

    property bool filled: false

    property bool vertical: false
    property bool flip: false

    property real minValue: 0
    property real maxValue: 1
    property real value: 0

    property list<real> snapPoints: []
    property real snapThreshold: 0.05

    property alias implicitWidth: backgroundRectangle.implicitWidth
    property alias implicitHeight: backgroundRectangle.implicitHeight

    function positionToValue(position: real, snap: bool): real {
        const paddedLength = sliderContainer.sliderLength - sliderContainer.knobPadding * 2 - sliderContainer.knobLength
        const paddedPosition = position - sliderContainer.knobPadding - sliderContainer.knobLength / 2
        const rawValue = (flip ? (paddedLength - paddedPosition) : paddedPosition) / paddedLength
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

        return Util.clamp(snappedValue, minValue, maxValue)
    }

    signal moved(value: real)

    cursorShape: enabled ? (vertical ? Qt.SizeVerCursor : Qt.SizeHorCursor) : Qt.ArrowCursor

    onPressed: (event) => {
        if (vertical) root.moved(positionToValue(mouseY, event.modifiers !== Qt.ControlModifier))
        else root.moved(positionToValue(mouseX, event.modifiers !== Qt.ControlModifier))
    }
    onPositionChanged: (event) => {
        if (isPressed) {
            if (vertical) root.moved(positionToValue(mouseY, event.modifiers !== Qt.ControlModifier))
            else root.moved(positionToValue(mouseX, event.modifiers !== Qt.ControlModifier))
        }
    }

    state: {
        if (enabled) {
            if (isPressed) return "pressed"
            if (isHovered) return "hovered"
            
            return "normal"
        } else {
            return "disabledNormal"
        }
    }

    states: [
        State {
            name: "pressed"
            PropertyChanges {
                root {
                    _modulation: Qt.rgba(1, 1, 1, 1)
                }

                backgroundRectangle {
                    border.color: backgroundBorderPressColor
                    color: backgroundPressColor
                }

                knobRectangle {
                    border.color: knobBorderPressColor
                    color: knobPressColor
                }

                fillRectangle {
                    border.color: fillBorderColor
                    color: fillColor
                }
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                root {
                    _modulation: Qt.rgba(1, 1, 1, 1)
                }

                backgroundRectangle {
                    border.color: backgroundBorderHoverColor
                    color: backgroundHoverColor
                }

                knobRectangle {
                    border.color: knobBorderHoverColor
                    color: knobHoverColor
                }

                fillRectangle {
                    border.color: fillBorderColor
                    color: fillColor
                }
            }
        },
        State {
            name: "normal"
            PropertyChanges {
                root {
                    _modulation: Qt.rgba(1, 1, 1, 1)
                }

                backgroundRectangle { 
                    border.color: backgroundBorderColor
                    color: backgroundColor
                }

                knobRectangle {
                    border.color: knobBorderColor
                    color: knobColor
                }

                fillRectangle {
                    border.color: fillBorderColor
                    color: fillColor
                }
            }
        },
        State {
            name: "disabledNormal"
            PropertyChanges {
                root {
                    _modulation: disabledModulation
                }

                backgroundRectangle {
                    border.color: { return Qt.rgba(
                        backgroundBorderColor.r * modulation.r,
                        backgroundBorderColor.g * modulation.g,
                        backgroundBorderColor.b * modulation.b,
                        backgroundBorderColor.a * modulation.a
                    ) }
                    color: { return Qt.rgba(
                        backgroundColor.r * modulation.r,
                        backgroundColor.g * modulation.g,
                        backgroundColor.b * modulation.b,
                        backgroundColor.a * modulation.a
                    ) }
                }

                knobRectangle {
                    border.color: { return Qt.rgba(
                        knobBorderColor.r * modulation.r,
                        knobBorderColor.g * modulation.g,
                        knobBorderColor.b * modulation.b,
                        knobBorderColor.a * modulation.a
                    ) }
                    color: { return Qt.rgba(
                        knobColor.r * modulation.r,
                        knobColor.g * modulation.g,
                        knobColor.b * modulation.b,
                        knobColor.a * modulation.a
                    ) }
                }

                fillRectangle {
                    border.color: { return Qt.rgba(
                        fillBorderColor.r * modulation.r,
                        fillBorderColor.g * modulation.g,
                        fillBorderColor.b * modulation.b,
                        fillBorderColor.a * modulation.a
                    ) }
                    color: { return Qt.rgba(
                        fillColor.r * modulation.r,
                        fillColor.g * modulation.g,
                        fillColor.b * modulation.b,
                        fillColor.a * modulation.a
                    ) }
                }
            }
        }
    ]

    Item {
        id: sliderContainer

        readonly property real rawValue: (value - minValue) / (maxValue + minValue)
        property real smoothedValue: rawValue

        readonly property real sliderThickness: 24
        readonly property real sliderLength: vertical ? parent.height : parent.width
        readonly property real fillLength: knobPadding * 2 + knobLength + (sliderLength - knobLength - knobPadding * 2) * smoothedValue
        readonly property real fillPosition: flip ? sliderLength - fillLength : 0
        readonly property real knobLength: 8
        readonly property real knobThickness: 16
        readonly property real knobPadding: (sliderThickness - knobThickness) / 2
        readonly property real knobPosition: knobPadding + (sliderLength - knobLength - knobPadding * 2) * (flip ? (1 - smoothedValue) : smoothedValue)

        implicitWidth: vertical ? backgroundRectangle.width : backgroundRectangle.width
        implicitHeight: vertical ? backgroundRectangle.height : backgroundRectangle.height

        Behavior on smoothedValue {
            PropertyAnimation {
                duration: Settings.animationSpeed.fast
                easing.type: Settings.animationEasing.easeOut
            }
        }

        Rectangle {
            id: backgroundRectangle

            x: vertical ? (parent.implicitWidth - implicitWidth) / 2 : 0
            y: vertical ? 0 : (parent.implicitHeight - implicitHeight) / 2

            implicitWidth: vertical ? sliderContainer.sliderThickness : 100 + sliderContainer.knobLength + sliderContainer.knobPadding * 2
            implicitHeight: vertical ? 100 + sliderContainer.knobLength + sliderContainer.knobPadding * 2 : sliderContainer.sliderThickness

            border {
                width: borderWidth
            }

            radius: Settings.radius.medium

            Behavior on color {
                ColorAnimation {
                    duration: Settings.animationSpeed.fast
                    easing.type: Settings.animationEasing.easeOut
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: Settings.animationSpeed.fast
                    easing.type: Settings.animationEasing.easeOut
                }
            }

            Rectangle {
                id: fillRectangle

                implicitWidth: vertical ? backgroundRectangle.width : sliderContainer.fillLength
                implicitHeight: vertical ? sliderContainer.fillLength : backgroundRectangle.height

                x: vertical ? 0 : sliderContainer.fillPosition
                y: vertical ? sliderContainer.fillPosition : 0

                border {
                    width: borderWidth
                }

                radius: Settings.radius.medium

                visible: filled

                Behavior on color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.fast
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
                Behavior on border.color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.fast
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
            }
        }

        Rectangle {
            id: knobRectangle

            x: vertical ? sliderContainer.knobPadding : sliderContainer.knobPosition
            y: vertical ? sliderContainer.knobPosition : sliderContainer.knobPadding

            implicitWidth: vertical ? sliderContainer.knobThickness : sliderContainer.knobLength
            implicitHeight: vertical ? sliderContainer.knobLength : sliderContainer.knobThickness

            border {
                width: borderWidth
            }

            radius: Settings.radius.small

            Behavior on color {
                ColorAnimation {
                    duration: Settings.animationSpeed.fast
                    easing.type: Settings.animationEasing.easeOut
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: Settings.animationSpeed.fast
                    easing.type: Settings.animationEasing.easeOut
                }
            }
        }

        Repeater {
            model: snapPoints

            Rectangle {
                required property real modelData
                readonly property real rawSnapPoint: (modelData - minValue) / (maxValue + minValue)

                readonly property bool snapped: Math.round(value * 100) / 100 === Math.round(modelData * 100) / 100

                readonly property real snapLength: 4
                property real snapThickness: snapped ? 12 : 4
                readonly property real snapLengthPadding: (sliderContainer.knobLength - snapLength) / 2
                readonly property real snapTicknessPadding: (sliderContainer.sliderThickness - snapThickness) / 2
                readonly property real snapPosition: sliderContainer.knobPadding + snapLengthPadding + (sliderContainer.sliderLength - sliderContainer.knobLength - (sliderContainer.knobPadding + snapLengthPadding * 2)) * (flip ? (1 - rawSnapPoint) : rawSnapPoint)

                x: vertical ? snapTicknessPadding : snapPosition
                y: vertical ? snapPosition : snapTicknessPadding

                implicitWidth: vertical ? snapThickness : snapLength
                implicitHeight: vertical ? snapLength : snapThickness

                color: snapped ? snapActiveColor : snapColor
                radius: Settings.radius.small

                Behavior on color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.slow
                        easing.type: Settings.animationEasing.easeOut
                    }
                }

                Behavior on snapThickness {
                    PropertyAnimation {
                        duration: Settings.animationSpeed.slow
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
            }
        }
    }
}