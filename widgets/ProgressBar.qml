import QtQuick

import qs.services
import qs.singletons
import qs.widgets



Rectangle {
    id: root

    property color backgroundColor: Settings.palette.background1
    property color backgroundBorderColor: Settings.palette.border
    
    property color fillColor: Settings.palette.accent
    property color fillBorderColor: Settings.palette.foreground2

    property color percentageColor: Settings.palette.foreground0
    property color percentageFillColor: Settings.palette.background0

    property int borderWidth: 0

    property bool vertical: false
    property bool flip: false

    property bool showPercentage: true
    property bool verticalPercentage: vertical
    property bool flipPercentage: false

    property real value: 0
    property bool useRound: false
    property string customText: ""
    readonly property int roundedValue: useRound ? Math.round(value * 100) : Math.floor(value * 100)

    readonly property real textLength: backgroundText.width

    implicitWidth: vertical ? 16 : 128
    implicitHeight: vertical ? 128 : 16

    color: backgroundColor

    border {
        width: borderWidth
        color: backgroundBorderColor
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

    Text {
        id: backgroundText

        text: customText === "" ? roundedValue + "%" : customText

        x: (root.width - contentWidth) / 2
        y: (root.height - contentHeight) / 2

        color: percentageColor

        rotation: verticalPercentage ? 90 : 0 * flipPercentage ? 180 : 0

        visible: showPercentage

        Behavior on color {
            ColorAnimation {
                duration: Settings.animationSpeed.fast
                easing.type: Settings.animationEasing.easeOut
            }
        }
    }

    Item {
        implicitWidth: vertical ? root.width : value * root.width
        implicitHeight: vertical ? value * root.height : root.height

        x: vertical ? 0 : (flip ? (1 - value) * root.width : 0)
        y: vertical ? (flip ? (1 - value) * root.height : 0) : 0

        clip: true

        Behavior on implicitWidth {
            enabled: !vertical
            PropertyAnimation {
                duration: Settings.animationSpeed.fast
                easing.type: Settings.animationEasing.easeOut
            }
        }
        Behavior on implicitHeight {
            enabled: vertical
            PropertyAnimation {
                duration: Settings.animationSpeed.fast
                easing.type: Settings.animationEasing.easeOut
            }
        }
        Behavior on x {
            enabled: !vertical
            PropertyAnimation {
                duration: Settings.animationSpeed.fast
                easing.type: Settings.animationEasing.easeOut
            }
        }
        Behavior on y {
            enabled: vertical
            PropertyAnimation {
                duration: Settings.animationSpeed.fast
                easing.type: Settings.animationEasing.easeOut
            }
        }

        Rectangle {
            implicitWidth: root.width
            implicitHeight: root.height

            x: vertical ? 0 : (flip ? -parent.x : 0)
            y: vertical ? (flip ? -parent.y : 0) : 0

            color: fillColor

            border {
                width: borderWidth
                color: fillBorderColor
            }

            topLeftRadius: root.topLeftRadius
            topRightRadius: root.topRightRadius
            bottomLeftRadius: root.bottomLeftRadius
            bottomRightRadius: root.bottomRightRadius

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

            Text {
                text: customText === "" ? roundedValue + "%" : customText

                x: (root.width - contentWidth) / 2
                y: (root.height - contentHeight) / 2

                color: percentageFillColor

                rotation: verticalPercentage ? 90 : 0 * flipPercentage ? 180 : 0

                visible: showPercentage

                Behavior on color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.fast
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
            }
        }
    }
}