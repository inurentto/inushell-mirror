import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.widgets
import qs.widgets.controls

Button {
    id: root

    property var app
    property bool highlighted: false

    implicitHeight: icon.implicitHeight + root.topPadding + root.bottomPadding

    backgroundColor: highlighted ? Config.theme.getAccent( ) : Config.theme.getBackground1( )
    backgroundHoverColor: highlighted ? Config.theme.getAccent( ) : Config.theme.getBackground2( )
    backgroundPressColor: highlighted ? Config.theme.getAccent( ) : Config.theme.getBackground0( )

    leftPadding: Config.theme.padding.normal
    rightPadding: Config.theme.padding.normal
    topPadding: Config.theme.padding.normal
    bottomPadding: Config.theme.padding.normal

    topLeftCornerRadius: Config.theme.cornerRadius.small
    topRightCornerRadius: Config.theme.cornerRadius.small
    bottomLeftCornerRadius: Config.theme.cornerRadius.small
    bottomRightCornerRadius: Config.theme.cornerRadius.small

    RowLayout {
        spacing: Config.theme.spacing.normal

        IconImage {
            id: icon

            source: Icons.getAppIcon( app.icon )
            implicitSize: 36

            visible: backer.paintedWidth * backer.paintedHeight > 0
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: interfaceWindow.getEntryTitleText( app )

                Layout.fillWidth: true

                color: highlighted ? Config.theme.getBackground0( ) : Config.theme.getForeground0( )

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                Behavior on color {
                    ColorAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
                    }
                }
            }

            Text {
                text: interfaceWindow.getEntryDescriptionText( app )
                font.pointSize: Config.theme.textSize.small

                Layout.fillWidth: true

                color: highlighted ? Config.theme.getBackground0( ) : Config.theme.getForeground2( )

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter

                elide: Text.ElideRight

                visible: interfaceWindow.getEntryDescriptionText( app ) !== ""

                Behavior on color {
                    ColorAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
                    }
                }
            }
        }
    }
}