import Quickshell.Widgets
import QtQuick

import qs.services
import qs.singletons
import qs.widgets



Control {
    id: root

    property color backgroundColor: Settings.palette.background1
    property color backgroundHoverColor: Settings.palette.background2
    property color backgroundPressColor: Settings.palette.background0
    property color borderColor: Settings.palette.background2
    property color borderHoverColor: Settings.palette.border
    property color borderPressColor: Settings.palette.accent

    property int borderWidth: 0

    property alias cornerRadius: backgroundRectangle.radius
    property alias topLeftCornerRadius: backgroundRectangle.topLeftRadius
    property alias topRightCornerRadius: backgroundRectangle.topRightRadius
    property alias bottomLeftCornerRadius: backgroundRectangle.bottomLeftRadius
    property alias bottomRightCornerRadius: backgroundRectangle.bottomRightRadius

    property alias implicitWidth: backgroundRectangle.implicitWidth
    property alias implicitHeight: backgroundRectangle.implicitHeight

    property real topPadding: Settings.spacing.medium
    property real bottomPadding: Settings.spacing.medium
    property real leftPadding: Settings.spacing.big
    property real rightPadding: Settings.spacing.big

    property bool toggleable: false
    property bool isToggled: false

    default property alias content: backgroundRectangle.data

    signal toggled()

    state: {
        if (enabled) {
            if (!toggleable && isPressed || toggleable && isToggled) return "pressed"
            if (isHovered) return "hovered"

            return "normal"
        } else {
            if (isPressed || isToggled) return "disabledPressed"

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
                    border.color: borderPressColor
                    color: backgroundPressColor
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
                    border.color: borderHoverColor
                    color: backgroundHoverColor
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
                    border.color: borderColor
                    color: backgroundColor
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
                        borderColor.r * modulation.r,
                        borderColor.g * modulation.g,
                        borderColor.b * modulation.b,
                        borderColor.a * modulation.a
                    ) }
                    color: { return Qt.rgba(
                        backgroundColor.r * modulation.r,
                        backgroundColor.g * modulation.g,
                        backgroundColor.b * modulation.b,
                        backgroundColor.a * modulation.a
                    ) }
                }
            }
        },
        State {
            name: "disabledPressed"
            PropertyChanges {
                root {
                    _modulation: disabledModulation
                }

                backgroundRectangle {
                    border.color: { return Qt.rgba(
                        borderPressColor.r * modulation.r,
                        borderPressColor.g * modulation.g,
                        borderPressColor.b * modulation.b,
                        borderPressColor.a * modulation.a
                    ) }
                    color: { return Qt.rgba(
                        backgroundPressColor.r * modulation.r,
                        backgroundPressColor.g * modulation.g,
                        backgroundPressColor.b * modulation.b,
                        backgroundPressColor.a * modulation.a
                    ) }
                }
            }
        }
    ]
    
    onClicked: (mouse) => {
        if (toggleable) {
            isToggled = !isToggled
            root.toggled()
        }
    }

    ClippingWrapperRectangle {
        id: backgroundRectangle

        topMargin: topPadding
        bottomMargin: bottomPadding
        leftMargin: leftPadding
        rightMargin: rightPadding

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
    }
}