//@ pragma IconTheme Papirus-Dark
//@ pragma NativeTextRendering
//@ pragma DropExpensiveFonts
//@ pragma DefaultEnv QT_QUICK_FLICKABLE_WHEEL_DECELERATION = 10000
//@ pragma DefaultEnv QSG_RENDER_LOOP=threaded
////@ pragma DefaultEnv QSG_RHI_BACKEND = vulkan

import QtQuick
import QtQuick.Effects
import Quickshell.Wayland

import Quickshell

//import InuShell

import qs.debug
import qs.services
import qs.modules.settings
import qs.modules.bar
import qs.modules.notifications
import qs.modules.launcher
import qs.modules.polkit



ShellRoot {
    id: root

    settings.watchFiles: true

    //Widgets {}

    SettingsWindow {}

    Bar {
        id: bar
    }

    NotificationPopupList {
        bar: bar
    }

    Launcher {}

    PolkitAgent {}

    LazyLoader {
        active: false

        PanelWindow {
            id: window

            WlrLayershell.layer: WlrLayer.Overlay

            color: "transparent"

            exclusionMode: ExclusionMode.Ignore

            implicitWidth: image.width
            implicitHeight: image.height

            anchors {
                left: true
                top: true
            }

            margins {
                left: 0
                top: 0
            }

            mask: Region { width: 0; height: 0 }

            property real horizontalSpeed: 10
            property real verticalSpeed: 10

            property color colorization: "#FFFFFF"

            function hit(): void {
                //horizontalSpeed += 1 * Math.sign(horizontalSpeed)
                //verticalSpeed += 1 * Math.sign(verticalSpeed)

                window.colorization = Qt.rgba(
                    Math.random(),
                    Math.random(),
                    Math.random(),
                    1
                )
            }

            Image {
                id: image

                sourceSize.height: 160

                source: Qt.resolvedUrl("/home/inurentto/Pictures/dvd.png")
                fillMode: Image.PreserveAspectCrop

                opacity: 1

                layer.enabled: true
                layer.effect: MultiEffect {
                    id: colorizationEffect

                    colorization: 1
                    brightness: 1
                    colorizationColor: window.colorization
                }
            }

            Timer {
                interval: 1 / 60 * 1000
                running: true
                repeat: true

                onTriggered: () => {
                    window.margins.left += window.horizontalSpeed
                    window.margins.top += window.verticalSpeed

                    if (window.margins.left + window.width > window.screen.width || window.margins.left <= 0) { window.horizontalSpeed *= -1; window.hit() }
                    if (window.margins.top + window.height > window.screen.height || window.margins.top <= 0) { window.verticalSpeed *= -1; window.hit() }
                }
            }

            Component.onCompleted: () => window.hit()
        }
    }
}