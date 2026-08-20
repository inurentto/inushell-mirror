import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.singletons
import qs.widgets
import qs.widgets.bar
import qs.resources
import qs.modules.bar.modules



Scope {
    id: root

    readonly property int height: Config.barHeight + Config.theme.padding.normal * 2 + Config.theme.padding.big * 2
    readonly property list<PanelWindow> windows: barVariants.instances

    Variants {
        id: barVariants
        model: Quickshell.screens

        PanelWindow {
            id: barWindow

            readonly property bool barTucked: HyprlandManager.monitorHasFullscreen(HyprlandManager.monitorFor(screen), true)

            required property var modelData
            screen: modelData

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: barWindow.barTucked ? -bar.height : 0
            }

            exclusiveZone: height - margins.top - (barWindow.barTucked ? height - Config.theme.spacing.big : 0)
            WlrLayershell.layer: WlrLayer.Overlay

            implicitHeight: root.height

            Behavior on margins.top {
                PropertyAnimation {
                    duration: Config.theme.animationSpeed.slow
                    easing.type: Config.theme.easingType
                }
            }

            Rectangle {
                id: barRectangle

                x: Config.theme.padding.big
                y: Config.theme.padding.big

                implicitWidth: barWindow.width - Config.theme.padding.big * 2
                implicitHeight: barWindow.height - Config.theme.padding.big * 2

                color: Config.theme.getBackground0()
                radius: Config.theme.cornerRadius.big

                Item {
                    x: Config.theme.padding.normal
                    y: Config.theme.padding.normal

                    implicitWidth: parent.width - Config.theme.padding.normal * 2
                    implicitHeight: parent.height - Config.theme.padding.normal * 2

                    RowLayout {
                        id: leftRow
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        spacing: Config.theme.spacing.big

                        ActionsModule { window: barWindow }
                        Separator { implicitHeight: parent.height; vertical: true }
                        WorkspacesModule { window: barWindow }
                        Separator { implicitHeight: parent.height; vertical: true }
                        MediaModule { window: barWindow }
                        Separator { implicitHeight: parent.height; vertical: true }
                        WindowModule { window: barWindow }
                    }

                    RowLayout {
                        id: centerRow
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        spacing: Config.theme.spacing.big

                        ClockModule { window: barWindow }
                    }

                    RowLayout {
                        id: rightRow
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        spacing: Config.theme.spacing.big

                        SystemTrayModule { window: barWindow }
                        //Separator { implicitHeight: parent.height; vertical: true }
                        //KeyLockModule { window: barWindow }
                        Separator { implicitHeight: parent.height; vertical: true }
                        AudioSinkModule { window: barWindow }
                        AudioSourceModule { window: barWindow }
                        Separator { implicitHeight: parent.height; vertical: true }
                        NetworkModule { window: barWindow }
                        BluetoothModule { window: barWindow }
                        PowerModule { window: barWindow }
                        Separator { implicitHeight: parent.height; vertical: true }
                        NotificationsModule { window: barWindow }
                    }
                }
            }

            MultiEffect {
                source: barRectangle
                anchors.fill: barRectangle
                shadowEnabled: true
                shadowBlur: 1.0
                blurMax: 16
                shadowColor: Qt.rgba(0, 0, 0, Config.theme.shadowOpacity)
            }
        }
    }

    Variants {
        id: popupVariants
        model: Quickshell.screens

        PanelWindow {
            id: popupWindow

            required property ShellScreen modelData
            readonly property PanelWindow correspondingBarWindow: root.windows.find(window => window.screen === modelData)
            screen: modelData

            implicitHeight: 600 + Config.theme.spacing.big * 2

            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: root.height - Config.theme.spacing.big
            }

            mask: Region {
                item: popupContainer
            }

            color: "transparent"

            visible: true

            ClippingRectangle {
                id: popupContainer

                readonly property ModuleArea moduleArea: PanelManager.currentOpenPanel
                readonly property bool isValidPanel: moduleArea && moduleArea.window === correspondingBarWindow
                readonly property int targetWidth: popupLoader.width + Config.theme.padding.normal * 2
                readonly property int targetX: {
                    if (!isValidPanel) return x
                    return Util.clamp(moduleArea.getContentX() + moduleArea.getContentWidth() / 2 - targetWidth / 2, Config.theme.spacing.big, popupWindow.width - targetWidth - Config.theme.spacing.big)
                }

                implicitWidth: targetWidth
                implicitHeight: Math.min( popupLoader.height + Config.theme.padding.normal * 2, popupWindow.height - Config.theme.spacing.big * 2 )
                x: targetX
                y: {
                    const moduleArea = PanelManager.currentOpenPanel
                    if (!moduleArea || moduleArea.window !== correspondingBarWindow) return -popupWindow.height + Config.theme.spacing.big
                    return Config.theme.spacing.big
                }

                opacity: {
                    const moduleArea = PanelManager.currentOpenPanel
                    if (!moduleArea || moduleArea.window !== correspondingBarWindow) return 0
                    return 1
                }

                color: Config.theme.getBackground0()
                radius: Config.theme.cornerRadius.big

                Behavior on implicitWidth {
                    enabled: slideAnimation.running || popupContainer.isValidPanel

                    PropertyAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
                    }
                }
                Behavior on implicitHeight {
                    enabled: slideAnimation.running || popupContainer.isValidPanel

                    PropertyAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
                    }
                }
                Behavior on x {
                    enabled: slideAnimation.running || popupContainer.isValidPanel

                    PropertyAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
                    }
                }
                Behavior on y {
                    PropertyAnimation {
                        id: slideAnimation

                        duration: Config.theme.animationSpeed.normal
                        easing.type: Config.theme.easingType
                    }
                }

                Behavior on opacity {
                    PropertyAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
                    }
                }

                HoverHandler {
                    onHoveredChanged: () => {
                        if (hovered) PanelManager.panelFocusGained()
                        else PanelManager.panelFocusLost()
                    }
                }

                Loader {
                    id: popupLoader

                    anchors.centerIn: parent

                    active: popupContainer.isValidPanel || slideAnimation.running
                    sourceComponent: {
                        if (popupContainer.isValidPanel && popupContainer.moduleArea.panelContent) return popupContainer.moduleArea.panelContent
                        return popupLoader.sourceComponent
                    }

                    onStatusChanged: () => {
                        if (status === Loader.Error) console.warn("Popup loader encountered an error!")
                    }
                }
            }

            MultiEffect {
                source: popupContainer
                anchors.fill: popupContainer
                shadowEnabled: true
                shadowBlur: 1.0
                blurMax: 16
                shadowColor: Qt.rgba(0, 0, 0, Config.theme.shadowOpacity)
            }
        }
    }
}