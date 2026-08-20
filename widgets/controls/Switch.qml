import Quickshell.Widgets
import QtQuick

import qs.singletons
import qs.widgets



Control {
    id: root

    property color backgroundColor: Config.theme.getBackground1()
    property color backgroundHoverColor: Config.theme.getBackground1()
    property color backgroundPressColor: Config.theme.getAccent()
    property color backgroundBorderColor: Config.theme.getBackground2()
    property color backgroundBorderHoverColor: Config.theme.getBorder()
    property color backgroundBorderPressColor: Config.theme.getAccent()

    property color knobColor: Config.theme.getForeground0();
    property color knobHoverColor: Config.theme.getForeground0();
    property color knobPressColor: Config.theme.getBackground0();
    property color knobBorderColor: Config.theme.getForeground2();
    property color knobBorderHoverColor: Config.theme.getForeground2();
    property color knobBorderPressColor: Config.theme.getForeground2();

    property int borderWidth: 0

    property real topPadding: Config.theme.padding.normal
    property real bottomPadding: Config.theme.padding.normal
    property real leftPadding: Config.theme.padding.big
    property real rightPadding: Config.theme.padding.big

    property bool isToggled: false

    signal toggled()

    state: {
        if ( enabled ) {
            if ( isToggled ) return "toggled"
            if ( isHovered ) return "hovered"

            return "normal"
        } else {
            if ( isToggled ) return "disabledToggled"

            return "disabledNormal"
        }
    }
    states: [
        State {
            name: "toggled"
            PropertyChanges {
                root {
                    _modulation: Qt.rgba( 1, 1, 1, 1 )
                }

                backgroundRectangle {
                    border.color: backgroundBorderPressColor
                    color: backgroundPressColor
                }

                knobRectangle {
                    border.color: knobBorderPressColor
                    color: knobPressColor

                    x: backgroundRectangle.width - knobRectangle.width - knobRectangle.y
                }
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                root {
                    _modulation: Qt.rgba( 1, 1, 1, 1 )
                }

                backgroundRectangle {
                    border.color: backgroundBorderHoverColor
                    color: backgroundHoverColor
                }

                knobRectangle {
                    border.color: knobBorderHoverColor
                    color: knobHoverColor

                    x: knobRectangle.y
                }
            }
        },
        State {
            name: "normal"
            PropertyChanges {
                root {
                    _modulation: Qt.rgba( 1, 1, 1, 1 )
                }

                backgroundRectangle { 
                    border.color: backgroundBorderColor
                    color: backgroundColor
                }

                knobRectangle {
                    border.color: knobBorderColor
                    color: knobColor

                    x: knobRectangle.y
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

                    x: knobRectangle.y
                }
            }
        },
        State {
            name: "disabledToggled"
            PropertyChanges {
                root {
                    _modulation: disabledModulation
                }

                backgroundRectangle {
                    border.color: { return Qt.rgba(
                        backgroundBorderPressColor.r * modulation.r,
                        backgroundBorderPressColor.g * modulation.g,
                        backgroundBorderPressColor.b * modulation.b,
                        backgroundBorderPressColor.a * modulation.a
                    ) }
                    color: { return Qt.rgba(
                        backgroundPressColor.r * modulation.r,
                        backgroundPressColor.g * modulation.g,
                        backgroundPressColor.b * modulation.b,
                        backgroundPressColor.a * modulation.a
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
                        knobPressColor.r * modulation.r,
                        knobPressColor.g * modulation.g,
                        knobPressColor.b * modulation.b,
                        knobPressColor.a * modulation.a
                    ) }

                    x: backgroundRectangle.width - knobRectangle.width - knobRectangle.y
                }
            }
        }
    ]
    
    onClicked: (mouse) => {
        isToggled = !isToggled
        root.toggled()
    }

    Rectangle {
        id: backgroundRectangle

        implicitWidth: 48
        implicitHeight: 24

        border {
            width: borderWidth
        }

        radius: implicitHeight / 2

        Behavior on color {
            ColorAnimation {
                duration: Config.theme.animationSpeed.fast
                easing.type: Config.theme.easingType
            }
        }
        Behavior on border.color {
            ColorAnimation {
                duration: Config.theme.animationSpeed.fast
                easing.type: Config.theme.easingType
            }
        }

        Rectangle {
            id: knobRectangle

            x: (backgroundRectangle.height - implicitWidth) / 2
            y: (backgroundRectangle.height - implicitHeight) / 2

            implicitWidth: 16
            implicitHeight: 16

            border {
                width: borderWidth
            }

            radius: implicitHeight / 2

            Behavior on x {
                PropertyAnimation {
                    duration: Config.theme.animationSpeed.fast
                    easing.type: Config.theme.easingType
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: Config.theme.animationSpeed.fast
                    easing.type: Config.theme.easingType
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: Config.theme.animationSpeed.fast
                    easing.type: Config.theme.easingType
                }
            }
        }
    }
}