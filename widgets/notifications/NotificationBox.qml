import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.resources
import qs.widgets
import qs.widgets.controls



MouseArea {
    id: root

    required property NotificationWrapper notification

    property bool showExpiration: true

    implicitHeight: childrenRect.height
    implicitWidth: Config.notificationWidth

    cursorShape: Qt.PointingHandCursor

    drag.target: parent
    drag.axis: Drag.XAxis
    drag.minimumX: 0
    drag.threshold: 16

    onReleased: () => {
        if (Math.abs(parent.x) >= width * 0.3) {
            notification.dismiss()
        } else {
            parent.x = 0
        }
    }

    onClicked: () => {
        notification.dismiss()
    }

    ClippingWrapperRectangle {
        id: container

        implicitWidth: root.width

        color: Config.theme.getBackground1()

        topLeftRadius: Config.theme.cornerRadius.big
        topRightRadius: Config.theme.cornerRadius.big
        bottomLeftRadius: Config.theme.cornerRadius.big
        bottomRightRadius: Config.theme.cornerRadius.big

        topMargin: Config.theme.padding.normal
        bottomMargin: Config.theme.padding.normal
        leftMargin: Config.theme.padding.normal
        rightMargin: Config.theme.padding.normal

        ColumnLayout {
            spacing: Config.theme.spacing.normal

            RowLayout {
                x: Config.theme.padding.normal
                y: Config.theme.padding.normal

                implicitWidth: root.width - Config.theme.padding.normal * 2

                spacing: Config.theme.spacing.normal
                
                IconImage {
                    source: Icons.getAppIcon(notification.appIcon, notification.appName)
                    implicitSize: 16

                    visible: source !== ""
                }

                Text {
                    id: appNameText

                    text: notification.appName
                    verticalAlignment: Text.AlignVCenter

                    elide: Text.ElideRight
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    TintedIcon {
                        source: Icons.getIcon("edit-clear-all")
                    }
                }
            }

            Separator {
                Layout.fillWidth: true
                implicitHeight: 9
            }

            RowLayout {
                spacing: Config.theme.spacing.big

                Layout.fillWidth: true

                ClippingWrapperRectangle {
                    color: "transparent"

                    radius: Config.theme.cornerRadius.normal

                    IconImage {
                        id: image

                        source: notification.image
                        implicitSize: 128
                    }

                    visible: image.source !== ""
                }

                ColumnLayout {
                    spacing: Config.theme.spacing.normal

                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        text: notification.summary
                        font.pointSize: Config.theme.textSize.smallTitle

                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true

                        text: notification.body

                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        maximumLineCount: 6
                    }
                }
            }

            RowLayout {
                id: actionButtonLayout
                spacing: Config.theme.spacing.small

                Repeater {
                    id: actionButtonRepeater
                    model: notification?.actions ?? model

                    Button {
                        id: actionButton

                        required property NotificationAction modelData

                        onClicked: () => {
                            modelData.invoke()
                        }

                        implicitWidth: (container.width - container.leftMargin - container.rightMargin - actionButtonLayout.spacing * Math.max(actionButtonRepeater.count - 1, 0)) / actionButtonRepeater.count

                        backgroundColor: Config.theme.getAccent()

                        RowLayout {
                            spacing: Config.theme.spacing.normal

                            TintedIcon {
                                source: Icons.getIcon(modelData.identifier)
                                tint: actionButton.hovered ? Config.theme.getForeground0() : Config.theme.getBackground0()

                                visible: notification.hasActionIcons

                                Behavior on tint {
                                    ColorAnimation {
                                        duration: Config.theme.animationSpeed.fast
                                        easing.type: Config.theme.easingType
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                            
                                text: modelData?.text ?? text
                                color: actionButton.hovered ? Config.theme.getForeground0() : Config.theme.getBackground0()
                                horizontalAlignment: notification.hasActionIcons ? Text.AlignLeft : Text.AlignHCenter

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
            }
        }
    }
}