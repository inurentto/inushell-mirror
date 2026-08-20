import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

import qs.singletons
import qs.widgets



Control {
    id: root

    property color backgroundColor: Config.theme.getBackground1()
    property color backgroundHoverColor: Config.theme.getBackground1()
    property color backgroundPressColor: Config.theme.getBackground1()
    property color borderColor: Config.theme.getBackground2()
    property color borderHoverColor: Config.theme.getBorder()
    property color borderPressColor: Config.theme.getAccent()

    property color textColor: Config.theme.getForeground0()
    property color placeholderTextColor: Config.theme.getBorder()
    property color selectionColor: Config.theme.getAccent()
    property color textSelectionColor: Config.theme.getBackground0()

    property alias color: textInput.color

    property int borderWidth: 0

    property alias font: textInput.font

    property alias cornerRadius: backgroundRectangle.radius
    property alias topLeftCornerRadius: backgroundRectangle.topLeftRadius
    property alias topRightCornerRadius: backgroundRectangle.topRightRadius
    property alias bottomLeftCornerRadius: backgroundRectangle.bottomLeftRadius
    property alias bottomRightCornerRadius: backgroundRectangle.bottomRightRadius

    property alias implicitWidth: backgroundRectangle.implicitWidth
    property alias implicitHeight: backgroundRectangle.implicitHeight

    property real topPadding: Config.theme.padding.small
    property real bottomPadding: Config.theme.padding.small
    property real leftPadding: Config.theme.padding.small
    property real rightPadding: Config.theme.padding.small

    readonly property bool isFocused: textInput.cursorVisible

    property alias cursorVisible: textInput.cursorVisible

    property alias text: textInput.text
    property alias placeholderText: placeholderText.text

    property alias selectByMouse: textInput.selectByMouse
    property alias echoMode: textInput.echoMode

    cursorShape: Qt.IBeamCursor

    signal accepted()
    signal unfocusRequested()
    signal textEdited()

    function forceActiveFocus() {
        textInput.forceActiveFocus()
    }

    state: {
        if (enabled) {
            if (isFocused) return "focused"
            if (isHovered) return "hovered"

            return "normal"
        } else {
            if (isFocused) return "disabledFocused"

            return "disabledNormal"
        }
    }
    states: [
        State {
            name: "focused"
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
            name: "disabledFocused"
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

    ClippingWrapperRectangle {
        id: backgroundRectangle

        topMargin: topPadding
        bottomMargin: bottomPadding
        leftMargin: leftPadding
        rightMargin: rightPadding

        border {
            width: borderWidth
        }

        radius: Config.theme.cornerRadius.normal

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

        TextInput {
            id: textInput

            selectByMouse: true

            color: root.textColor
            selectionColor: root.selectionColor
            selectedTextColor: root.textSelectionColor

            topPadding: root.topPadding
            bottomPadding: root.bottomPadding
            leftPadding: root.leftPadding
            rightPadding: root.rightPadding

            font.pointSize: Config.theme.textSize.normal
            verticalAlignment: Text.AlignVCenter

            onAccepted: () => root.accepted()
            onTextEdited: () => root.textEdited()

            Keys.onEscapePressed: () => {
                root.unfocusRequested()
            }

            Text {
                id: placeholderText

                anchors.verticalCenter: parent.verticalCenter

                x: root.leftPadding
                y: root.topPadding                

                text: ""

                color: placeholderTextColor
                font.pointSize: textInput.font.pointSize
                verticalAlignment: Text.AlignVCenter

                visible: textInput.displayText.length <= 0 && !textInput.cursorVisible
            }
        }
    }
}