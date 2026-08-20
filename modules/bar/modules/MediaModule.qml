import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.singletons
import qs.widgets
import qs.widgets.controls
import qs.widgets.bar
import qs.resources



Module {
    id: root

    property MediaPlayer activePlayer: MediaManager.activePlayer

    property int volumeScrollY: 0

    visible: activePlayer !== null

    onClicked: (mouse, area) => {
        if (!root.activePlayer) return

        if (area.name === "state") {
            if (mouse.button === Qt.LeftButton && root.activePlayer.rawPlayer.canTogglePlaying) root.activePlayer.rawPlayer.togglePlaying()
            else if (mouse.button === Qt.RightButton && root.activePlayer.rawPlayer.canSeek) {
                const targetPosition = mouse.x / stateProgressBar.width
                root.activePlayer.rawPlayer.seek(targetPosition * root.activePlayer.length - root.activePlayer.rawPlayer.position)
            }
            else if (mouse.button === Qt.MiddleButton && root.activePlayer.rawPlayer.canRaise) root.activePlayer.rawPlayer.raise()
        } else if (area.name === "loop") {
            if (mouse.button === Qt.LeftButton) {
                switch (root.activePlayer.rawPlayer.loopState) {
                    case MprisLoopState.None: root.activePlayer.rawPlayer.loopState = MprisLoopState.Playlist; break
                    case MprisLoopState.Playlist: root.activePlayer.rawPlayer.loopState = MprisLoopState.Track; break
                    case MprisLoopState.Track: root.activePlayer.rawPlayer.loopState = MprisLoopState.None; break
                }
            } else if (mouse.button === Qt.RightButton) {
                switch (root.activePlayer.rawPlayer.loopState) {
                    case MprisLoopState.None: root.activePlayer.rawPlayer.loopState = MprisLoopState.Track; break
                    case MprisLoopState.Playlist: root.activePlayer.rawPlayer.loopState = MprisLoopState.None; break
                    case MprisLoopState.Track: root.activePlayer.rawPlayer.loopState = MprisLoopState.Playlist; break
                }
            }
        } else if (area.name === "shuffle") root.activePlayer.rawPlayer.shuffle = !root.activePlayer.rawPlayer.shuffle
    }
    onWheel: (wheel, area) => {
        if (!root.activePlayer) return

        if (area.name === "state") {
            if (wheel.angleDelta.x < 0) {
                if (root.activePlayer.rawPlayer.canGoNext) root.activePlayer.rawPlayer.next()
            } else if (wheel.angleDelta.x > 0) {
                if (root.activePlayer.rawPlayer.canGoPrevious) root.activePlayer.rawPlayer.previous()
            }
        } else if (area.name === "volume") {
            if (root.activePlayer.rawPlayer.canControl && root.activePlayer.rawPlayer.volumeSupported) {
                root.volumeScrollY += wheel.angleDelta.y
                
                if (Math.abs(root.volumeScrollY) >= 15 * 10) {
                    root.activePlayer.rawPlayer.volume += 1 / 100 * Math.sign(root.volumeScrollY)
                    root.volumeScrollY = 0
                }

                if (root.activePlayer.rawPlayer.volume > 1) root.activePlayer.rawPlayer.volume = 1
                else if (root.activePlayer.rawPlayer.volume < 0) root.activePlayer.rawPlayer.volume = 0
            }
        }
    }

    function formatTime(time: real): string {
        let hours = Math.floor(time / 60 / 60)
        let minutes = Math.floor(time / 60 - hours * 60)
        let seconds = Math.floor(time - minutes * 60 - hours * 60 * 60)

        let minutesString = minutes >= 10 ? minutes.toString() : "0" + minutes
        let secondsString = seconds >= 10 ? seconds.toString() : "0" + seconds

        if (hours > 0) {
            let hoursString = hours >= 10 ? hours.toString() : "0" + hours
            return hoursString + ":" + minutesString + ":" + secondsString
        } else {
            return minutesString + ":" + secondsString
        }
    }

    areas: [
        ModuleArea {
            name: "trackArt"
            window: root.window
            acceptedButtons: Qt.NoButton

            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0

            enabled: root.activePlayer.trackArtUrl !== ""

            aspectRatio: 1

            panelContent: Component {
                ClippingWrapperRectangle {
                    color: "transparent"
                    radius: Config.theme.cornerRadius.normal

                    Image {
                        source: root.activePlayer.trackArtUrl
                        retainWhileLoading: true
                        asynchronous: true
                        fillMode: Image.PreserveAspectCrop
                        sourceSize.height: 512
                    }
                }
            }

            Image {
                id: coverImage

                source: root.activePlayer.trackArtUrl
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: width
                sourceSize.height: height
            }
        },

        ModuleArea {
            name: "state"
            window: root.window
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0

            panelContent: Component {
                RowLayout {
                    spacing: Config.theme.spacing.small

                    Button {
                        enabled: MediaManager.players.length > 1

                        onClicked: () => {
                            MediaManager.incrementActivePlayer(-1)
                        }

                        Text {
                            text: "<"
                        }
                    }

                    Item {
                        implicitWidth: childrenRect.width + Config.theme.padding.normal * 2

                        RowLayout {
                            anchors.centerIn: parent

                            spacing: Config.theme.spacing.normal

                            IconImage {
                                source: Icons.getAppIcon(root.activePlayer.rawPlayer.identity)
                                implicitSize: 16

                                visible: source != ""
                            }

                            Text {
                                text: root.activePlayer.rawPlayer.identity
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    Button {
                        enabled: MediaManager.players.length > 1

                        onClicked: () => {
                            MediaManager.incrementActivePlayer(1)
                        }

                        Text {
                            text: ">"
                        }
                    }
                }
            }

            ProgressBar {
                id: stateProgressBar

                implicitWidth: textLength + Config.theme.padding.normal * 2

                showPercentage: true
                customText: {
                    if (root.activePlayer.lengthSupported) return `${root.activePlayer.trackArtist} - ${root.activePlayer.trackTitle} [${formatTime(root.activePlayer.rawPlayer.position)} / ${formatTime(root.activePlayer.length)}]`
                    else return `${root.activePlayer.trackArtist} - ${root.activePlayer.trackTitle}`
                }

                backgroundColor: "transparent"
                fillColor: root.activePlayer.rawPlayer.isPlaying ? Config.theme.getAccent() : Config.theme.getBackground2()
                percentageFillColor: root.activePlayer.rawPlayer.isPlaying ? Config.theme.getBackground0() : Config.theme.getForeground0()

                radius: 0
                borderWidth: 0

                value: root.activePlayer.lengthSupported ? root.activePlayer.rawPlayer.position / root.activePlayer.length : 1
                useRound: true
            }
        },

        // TODO: Add option so user can choose where loop and shuffle buttons are located.
        ModuleArea {
            name: "loop"
            window: root.window
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            enabled: root.activePlayer && root.activePlayer.loopSupported

            aspectRatio: 1

            panelContent: Component {
                Text {
                    text:  {
                        switch (root.activePlayer.rawPlayer.loopState) {
                            case MprisLoopState.None: return "Repeat: Off"
                            case MprisLoopState.Playlist: return "Repeat: On"
                            case MprisLoopState.Track: return "Repeat: Track"
                        }
                    }
                }
            }

            TintedIcon {
                source: {
                    switch (root.activePlayer.rawPlayer.loopState) {
                        case MprisLoopState.None: return Icons.getIcon("media-repeat-none")
                        case MprisLoopState.Playlist: return Icons.getIcon("media-repeat-all")
                        case MprisLoopState.Track: return Icons.getIcon("media-repeat-single")
                    }
                }
            }
        },

        ModuleArea {
            name: "shuffle"
            window: root.window
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            enabled: root.activePlayer && root.activePlayer.shuffleSupported

            aspectRatio: 1

            panelContent: Component {
                Text {
                    text: "Shuffle: " + (root.activePlayer.rawPlayer.shuffle ? "On" : "Off")
                }
            }

            TintedIcon {
                source: root.activePlayer.rawPlayer.shuffle ? Icons.getIcon("media-playlist-shuffle") : Icons.getIcon("media-playlist-normal")
            }
        },

        ModuleArea {
            name: "volume"
            window: root.window
            acceptedButtons: Qt.NoButton

            enabled: root.activePlayer && root.activePlayer.rawPlayer.volumeSupported

            topPadding: 0
            bottomPadding: 0
            leftPadding: 0
            rightPadding: 0

            panelContent: Component {
                Text {
                    text: "Volume: " + volumeProgressBar.roundedValue + "%"
                }
            }

            ProgressBar {
                id: volumeProgressBar

                implicitWidth: 48

                backgroundColor: "transparent"

                radius: 0
                borderWidth: 0

                vertical: true
                flip: true

                verticalPercentage: false

                value: root.activePlayer.rawPlayer.canControl && root.activePlayer.rawPlayer.volumeSupported ? root.activePlayer.rawPlayer.volume : 0
            }
        }
    ]

    Timer {
        running: root.activePlayer && root.activePlayer.lengthSupported
        interval: 100
        triggeredOnStart: true
        repeat: true
        onTriggered: root.activePlayer.rawPlayer.positionChanged()
    }
}