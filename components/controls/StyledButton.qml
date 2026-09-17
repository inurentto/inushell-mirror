import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.components
import qs.components.controls



StyledAbstractButton {
    id: root

    property bool checkable: false

    property bool flat: false

    property alias text: label.text
    property string icon: ""

    property color backgroundColor: Settings.palette.background1
    property color backgroundHoverColor: Settings.palette.background2
    property color backgroundDownColor: Settings.palette.background0

    property color backgroundCheckedColor: Settings.palette.accent
    property color backgroundCheckedHoverColor: Settings.palette.foreground1
    property color backgroundCheckedDownColor: Settings.palette.foreground2

    property color textColor: Settings.palette.foreground0
    property color textCheckedColor: Settings.palette.background1

    leftPadding: Settings.spacing.big
    rightPadding: Settings.spacing.big
    topPadding: Settings.spacing.medium
    bottomPadding: Settings.spacing.medium

    background: Rectangle {
        implicitWidth: root.childrenRect.width
        implicitHeight: root.childrenRect.height

        color: {
            if (enabled) {
                if (checked) {
                    if (down) return backgroundCheckedDownColor
                    else if (hovered) return backgroundCheckedHoverColor
                    return backgroundCheckedColor
                } else {
                    if (down) return backgroundDownColor
                    else if (hovered) return backgroundHoverColor
                    else if (flat) return "transparent" // Transparent is #00000000 which means that there are some frames where the color is dark (#00FFFFFF multiplied by Settings.palette.background2?)
                    return backgroundColor
                }
            } else {
                if (checked) return backgroundCheckedColor
                else if (flat) return "transparent"
                return backgroundDownColor
            }
        }
        topLeftRadius: {
            if (!groupedAndInSequence) return Settings.radius.medium
            if (firstInSequence) return Settings.radius.medium
            return Settings.radius.small
        }
        topRightRadius: {
            if (!groupedAndInSequence) return Settings.radius.medium
            if (firstInSequence && verticalSequence || lastInSequence && !verticalSequence) return Settings.radius.medium
            return Settings.radius.small
        }
        bottomLeftRadius: {
            if (!groupedAndInSequence) return Settings.radius.medium
            if (firstInSequence && !verticalSequence || lastInSequence && verticalSequence) return Settings.radius.medium
            return Settings.radius.small
        }
        bottomRightRadius: {
            if (!groupedAndInSequence) return Settings.radius.medium
            if (lastInSequence) return Settings.radius.medium
            return Settings.radius.small
        }

        Behavior on color {
            ColorAnimation {
                duration: Settings.animationSpeed.normal
                easing.type: Settings.animationEasing.easeOut
            }
        }
    }

    contentItem: RowLayout {
        spacing: Settings.spacing.medium

        ColoredIcon {
            visible: icon !== ""

            source: icon
            color: label.color
        }

        StyledText {
            id: label
            visible: text !== ""

            Layout.fillWidth: true

            text: ""

            color: checked ? textCheckedColor : textColor
            font: root.font

            horizontalAlignment: icon !== "" ? Text.AlignLeft : Text.AlignHCenter

            Behavior on color {
                ColorAnimation {
                    duration: Settings.animationSpeed.normal
                    easing.type: Settings.animationEasing.easeOut
                }
            }
        }
    }

    onClicked: (mouse) => {
        if (checkable) setChecked(!checked)
    }
}