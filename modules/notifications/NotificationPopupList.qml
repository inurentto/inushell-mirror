import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.notifications
import qs.modules.bar



Scope {
    required property Bar bar

    PanelWindow {
        id: notificationsPanel

        color: "transparent"

        anchors {
            bottom: true
            right: true
        }

        margins {
            bottom: HyprlandManager.monitorHasFullscreen(HyprlandManager.monitorFor(screen)) ? 0 : -bar.height + Settings.spacing.big
        }

        implicitWidth: Config.notificationWidth + Settings.spacing.big * 2
        implicitHeight: HyprlandManager.monitorFor(screen).height

        mask: Region {
            x: Settings.spacing.big; y: Settings.spacing.big
            width: Config.notificationWidth; height: Math.min(notificationListView.contentHeight, notificationListView.height)
        }

        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay

        Behavior on margins.bottom {
            PropertyAnimation {
                duration: Settings.animationSpeed.slow
                easing.type: Settings.animationEasing.easeOut
            }
        }

        StyledListView {
            id: notificationListView

            model: ScriptModel {
                values: NotificationsManager.popups.filter(n => true) // Fuckass hack to get ListView.onRemove working (cause otherwise it is counted as a ref not an actual value!!!)
            }

            x: Settings.spacing.big
            y: Settings.spacing.big

            width: notificationsPanel.width - Settings.spacing.big * 2
            height: notificationsPanel.height - Settings.spacing.big * 2 + (HyprlandManager.monitorHasFullscreen(HyprlandManager.monitorFor(notificationsPanel.screen)) ? 0 : -bar.height + Settings.spacing.big)
            clip: false

            orientation: Qt.Vertical

            displaced: Transition {
                NumberAnimation { properties: "y"; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
            }

            delegate: Item {
                id: wrapper

                required property var modelData

                implicitWidth: notificationsPanel.width
                implicitHeight: childrenRect.height

                ListView.onRemove: removeAnimation.start()

                x: notificationListView.width
                opacity: 0

                SequentialAnimation {
                    id: removeAnimation
                    PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: true }
                    ParallelAnimation {
                        NumberAnimation { target: wrapper; property: "x"; to: notificationListView.width; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
                        NumberAnimation { target: wrapper; property: "opacity"; to: 0; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
                    }
                    PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false }
                }

                ParallelAnimation {
                    id: addAnimation
                    running: true
                    NumberAnimation { target: wrapper; property: "x"; to: 0; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
                    NumberAnimation { target: wrapper; property: "opacity"; to: 1; duration: Settings.animationSpeed.normal; easing.type: Settings.animationEasing.easeOut }
                }

                NotificationBox {
                    id: content

                    notification: modelData
                }

                MultiEffect {
                    source: content
                    anchors.fill: content
                    shadowEnabled: true
                    shadowBlur: 1.0
                    blurMax: 16
                    shadowColor: Qt.rgba(0, 0, 0, Config.theme.shadowOpacity)
                }
            }

            Behavior on height {
                PropertyAnimation {
                    duration: Settings.animationSpeed.slow
                    easing.type: Settings.animationEasing.easeOut
                }
            }
        }
    }
}