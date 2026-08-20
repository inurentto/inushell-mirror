import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.widgets
import qs.widgets.controls
import qs.widgets.bar
import qs.resources




Module {
    id: root

    property int scrollY

    onClicked: (mouse, area) => {
        if (area.name === "volume") AudioManager.sink.audio.muted = !AudioManager.sink.audio.muted
    }
    onWheel: (wheel, area) => {
        if (area.name === "volume") {
            root.scrollY += wheel.angleDelta.y
            
            if (Math.abs(root.scrollY) >= 15 * 5) {
                AudioManager.sink.audio.volume += 1 / 100 * Math.sign(root.scrollY)
                root.scrollY = 0
            }

            if (AudioManager.sink.audio.volume > 1) AudioManager.sink.audio.volume = 1
            else if (AudioManager.sink.audio.volume < 0) AudioManager.sink.audio.volume = 0
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
                    spacing: Config.theme.spacing.normal

                    Text {
                        Layout.fillWidth: true

                        text: "Sink"
                        font.pointSize: Config.theme.textSize.smallTitle
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text {
                        Layout.fillWidth: true

                        text: AudioManager.sink.description
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
        }

            TintedIcon {
                source: Icons.getSinkVolumeIcon(AudioManager.sinkVolume, AudioManager.sinkMuted)
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

            borderColor: AudioManager.sinkMuted ? Config.theme.getRed() : Config.theme.getBackground2()

            panelContent: Component {
                ColumnLayout {
                    spacing: Config.theme.spacing.normal

                    width: 300

                    Repeater {
                        id: repeater

                        model: Pipewire.nodes.values.filter(n => n.audio && n.isStream && n.isSink)

                        ColumnLayout {
                            spacing: Config.theme.spacing.normal

                            required property var modelData
                            required property int index

                            readonly property string name: {
                                if (modelData.properties["application.name"] !== undefined) return modelData.properties["application.name"]
                                if (modelData.nickname !== "") return modelData.nickname
                                if (modelData.description !== "") return modelData.description
                                return modelData.name
                            }
                            readonly property string icon: {
                                let candidateIcon = Icons.getAppIcon(modelData.properties["application.icon-name"])
                                if (candidateIcon !== "") return candidateIcon

                                candidateIcon = Icons.getAppIcon(name)
                                if (candidateIcon !== "") return candidateIcon

                                candidateIcon = Icons.getAppIcon(modelData.properties["application.process.binary"])
                                if (candidateIcon !== "") return candidateIcon

                                return ""
                            }

                            PwObjectTracker {
                                objects: [modelData]
                            }

                            RowLayout {
                                spacing: Config.theme.spacing.normal

                                IconImage {
                                    source: icon
                                    implicitSize: 16

                                    visible: icon !== ""
                                }

                                Text {
                                    text: modelData.name
                                }
                            }

                            RowLayout {
                                spacing: Config.theme.spacing.normal

                                Text {
                                    text: Math.floor(modelData.audio.volume * 100) + "%"
                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Slider {
                                    filled: true

                                    implicitWidth: 230

                                    value: modelData.audio.volume
                                    maxValue: 1.5
                                    snapPoints: [ 0.5, 1 ]

                                    fillColor: modelData.audio.volume > 1 ? Config.theme.getRed() : Config.theme.getAccent()

                                    onMoved: (value) => {
                                        modelData.audio.volume = value
                                    }
                                }
                            }

                            Separator {
                                Layout.fillWidth: true

                                visible: index !== repeater.count - 1
                            }
                        }
                    }
                }
            }

            ProgressBar {
                implicitWidth: 48

                backgroundColor: "transparent"
                fillColor: AudioManager.sinkMuted ? Config.theme.getRed() : Config.theme.getAccent()

                radius: 0
                borderWidth: 0

                vertical: true
                flip: true

                verticalPercentage: false

                value: AudioManager.sinkVolume
                useRound: true
            }
        }
    ]
}