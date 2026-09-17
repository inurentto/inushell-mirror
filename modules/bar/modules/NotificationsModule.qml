import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.controls
import qs.widgets.bar
import qs.widgets.notifications
import qs.modules.notifications
import qs.resources




Module {
    id: root

    onClicked: () => {
        NotificationsManager.doNotDisturb = !NotificationsManager.doNotDisturb
    }

    areas: [
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.LeftButton

            aspectRatio: 1

            panelContent: Component {
                ColumnLayout {
                    width: Config.notificationWidth

                    spacing: Settings.spacing.medium

                    StyledListView {
                        id: notificationListView

                        Layout.fillWidth: true

                        model: ScriptModel {
                            values: NotificationsManager.openNonTransient.filter(n => true) // Fuckass hack to get ListView.onRemove working (cause otherwise it is counted as a ref not an actual value!!!)
                        }

                        height: Math.min(600 - Settings.spacing.medium * 2, contentHeight)
                        clip: true

                        orientation: Qt.Vertical

                        displaced: Transition {
                            NumberAnimation { properties: "y"; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
                        }

                        delegate: Item {
                            id: wrapper

                            required property var modelData

                            implicitWidth: Config.notificationWidth
                            implicitHeight: childrenRect.height

                            ListView.onRemove: removeAnimation.start()

                            SequentialAnimation {
                                id: removeAnimation
                                PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
                                ParallelAnimation {
                                    NumberAnimation { target: wrapper; property: "x"; to: 600; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
                                    NumberAnimation { target: wrapper; property: "opacity"; to: 0; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
                                }
                                PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
                            }

                            NotificationBox {
                                id: content

                                implicitWidth: Config.notificationWidth

                                notification: modelData
                                showExpiration: false
                            }
                        }

                        visible: NotificationsManager.open.length > 0

                        ScrollBar.vertical: ScrollBar {}
                    }

                    Text {
                        Layout.fillWidth: true

                        text: "No notifications :("
                        color: Settings.palette.foreground2
                        horizontalAlignment: Text.AlignHCenter

                        visible: NotificationsManager.open.length === 0
                    }
                }
            }

            TintedIcon {
                source: {
                    if (NotificationsManager.doNotDisturb) return Icons.getIcon("notification-disabled-symbolic")
                    if (NotificationsManager.open.length > 0) return Icons.getIcon("notification-new-symbolic")
                    return Icons.getIcon("notification-symbolic")
                }
            }
        }
    ]
}