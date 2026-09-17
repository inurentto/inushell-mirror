import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.bar
import qs.resources




Module {
    id: root

    property int scrollY

    onClicked: (mouse, area) => {
        if (area.name === "volume") AudioManager.source.audio.muted = !AudioManager.source.audio.muted
    }
    onWheel: (wheel, area) => {
        if (area.name === "volume") {
            root.scrollY += wheel.angleDelta.y
            
            if (Math.abs(root.scrollY) >= 15 * 5) {
                AudioManager.source.audio.volume += 1 / 100 * Math.sign(root.scrollY)
                root.scrollY = 0
            }

            if (AudioManager.source.audio.volume > 1) AudioManager.source.audio.volume = 1
            else if (AudioManager.source.audio.volume < 0) AudioManager.source.audio.volume = 0
        }
    }

    areas: [
        ModuleArea {
            name: "device"
            window: root.window
            acceptedButtons: Qt.NoButton

            aspectRatio: 1

            panelContent: Component {
                ColumnLayout {
                    spacing: Settings.spacing.medium

                    Text {
                        Layout.fillWidth: true

                        text: "Source"
                        font.pointSize: Settings.fontSize.smallTitle
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text {
                        Layout.fillWidth: true

                        text: AudioManager.source.description
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            TintedIcon {
                source: Icons.getSourceVolumeIcon(AudioManager.sourceVolume, AudioManager.sourceMuted)
            }
        },

        ModuleArea {
            name: "volume"
            window: root.window
            acceptedButtons: Qt.LeftButton

            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0

            borderColor: AudioManager.sourceMuted ? Settings.palette.red : Settings.palette.background2

            panelContent: Component {
                ColumnLayout {
                    spacing: Settings.spacing.medium

                    Text {
                        text: "Source Volume"
                    }
                }
            }

            ProgressBar {
                implicitWidth: 48

                backgroundColor: "transparent"
                fillColor: AudioManager.sourceMuted ? Settings.palette.red : Settings.palette.accent

                radius: 0
                borderWidth: 0

                vertical: true
                flip: true

                verticalPercentage: false

                value: AudioManager.sourceVolume
                useRound: true
            }
        }
    ]
}