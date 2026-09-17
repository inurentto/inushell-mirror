import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import qs.services
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

        color: Settings.palette.background1

        topLeftRadius: Settings.radius.big
        topRightRadius: Settings.radius.big
        bottomLeftRadius: Settings.radius.big
        bottomRightRadius: Settings.radius.big

        topMargin: Settings.spacing.medium
        bottomMargin: Settings.spacing.medium
        leftMargin: Settings.spacing.medium
        rightMargin: Settings.spacing.medium

        ColumnLayout {
            spacing: Settings.spacing.medium

            RowLayout {
                x: Settings.spacing.medium
                y: Settings.spacing.medium

                implicitWidth: root.width - Settings.spacing.medium * 2

                spacing: Settings.spacing.medium
                
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
                spacing: Settings.spacing.big

                Layout.fillWidth: true

                ClippingWrapperRectangle {
                    color: "transparent"

                    radius: Settings.radius.medium

                    IconImage {
                        id: image

                        source: notification.image
                        implicitSize: 128
                    }

                    visible: image.source !== ""
                }

                ColumnLayout {
                    spacing: Settings.spacing.medium

                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        text: notification.summary
                        font.pointSize: Settings.fontSize.smallTitle

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
                spacing: Settings.spacing.small

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

                        backgroundColor: Settings.palette.accent

                        RowLayout {
                            spacing: Settings.spacing.medium

                            TintedIcon {
                                source: Icons.getIcon(modelData.identifier)
                                tint: actionButton.hovered ? Settings.palette.foreground0 : Settings.palette.background0

                                visible: notification.hasActionIcons

                                Behavior on tint {
                                    ColorAnimation {
                                        duration: Settings.animationSpeed.fast
                                        easing.type: Settings.animationEasing.easeOut
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                            
                                text: modelData?.text ?? text
                                color: actionButton.hovered ? Settings.palette.foreground0 : Settings.palette.background0
                                horizontalAlignment: notification.hasActionIcons ? Text.AlignLeft : Text.AlignHCenter

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
            }
        }
    }
}