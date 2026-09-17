import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

import qs.services
import qs.singletons
import qs.components



Control {
    id: root

    property alias text: textInput.text
    property string placeholderText: "i am a very long placeholder text"

    property alias textColor: textInput.color
    property alias placeholderTextColor: placeholder.color
    
    property alias selectionColor: textInput.selectionColor
    property alias selectedTextColor: textInput.selectedTextColor

    function forceActiveFocus() {
        textInput.forceActiveFocus()
    }

    signal textEdited()

    implicitWidth: 200

    padding: Settings.spacing.medium

    hoverEnabled: true

    opacity: !enabled ? 0.5 : 1

    background: Rectangle {
        color: hovered ? Settings.palette.background2 : Settings.palette.background1
        radius: Settings.radius.medium
    }

    contentItem: TextInput {
        id: textInput

        width: root.width

        activeFocusOnPress: true
        selectByMouse: true

        clip: true

        renderType: TextInput.NativeRendering

        color: Settings.palette.foreground0
        selectionColor: Settings.palette.accent
        selectedTextColor: Settings.palette.background1

        font.pointSize: Settings.fontSize.normal

        onTextEdited: () => root.textEdited()

        Keys.onEscapePressed: () => deselect()

        StyledText {
            id: placeholder

            visible: textInput.displayText.length <= 0

            text: placeholderText
            color: Settings.palette.foreground2
        }

        Rectangle {
            visible: textInput.positionToRectangle(0 * textInput.cursorPosition).x < 0 // Added "textInput.cursorPosition" so qml creates a binding for it

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom

                leftMargin: -2
            }

            implicitWidth: 12

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: background.color }
                GradientStop { position: 1; color: "transparent" }
            }
        }
        Rectangle {
            visible: {
                if (placeholder.visible) return placeholder.contentWidth > textInput.width
                else return textInput.positionToRectangle(textInput.length + textInput.cursorPosition * 0).x > textInput.width // Added "textInput.cursorPosition" so qml creates a binding for it
            }

            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom

                rightMargin: -2
            }

            implicitWidth: 12

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0; color: "transparent" }
                GradientStop { position: 1; color: background.color }
            }
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
        cursorShape: Qt.IBeamCursor

        hoverEnabled: root.hoverEnabled

        onPressed: (mouse) => mouse.accepted = false
    }
}