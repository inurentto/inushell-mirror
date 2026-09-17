import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.controls



Button {
    id: root

    property var app
    property bool highlighted: false

    implicitHeight: icon.implicitHeight + root.topPadding + root.bottomPadding

    backgroundColor: highlighted ? Settings.palette.accent : Settings.palette.background1
    backgroundHoverColor: highlighted ? Settings.palette.accent : Settings.palette.background2
    backgroundPressColor: highlighted ? Settings.palette.accent : Settings.palette.background0

    leftPadding: Settings.spacing.medium
    rightPadding: Settings.spacing.medium
    topPadding: Settings.spacing.medium
    bottomPadding: Settings.spacing.medium

    topLeftCornerRadius: Settings.radius.small
    topRightCornerRadius: Settings.radius.small
    bottomLeftCornerRadius: Settings.radius.small
    bottomRightCornerRadius: Settings.radius.small

    RowLayout {
        spacing: Settings.spacing.medium

        IconImage {
            id: icon

            source: Icons.getAppIcon(app.icon)
            implicitSize: 36

            visible: backer.paintedWidth * backer.paintedHeight > 0
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: interfaceWindow.getEntryTitleText(app)

                Layout.fillWidth: true

                color: highlighted ? Settings.palette.background0 : Settings.palette.foreground0

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                Behavior on color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.fast
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
            }

            Text {
                text: interfaceWindow.getEntryDescriptionText(app)
                font.pointSize: Settings.fontSize.small

                Layout.fillWidth: true

                color: highlighted ? Settings.palette.background0 : Settings.palette.foreground2

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                elide: Text.ElideRight

                visible: interfaceWindow.getEntryDescriptionText(app) !== ""

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