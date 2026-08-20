import Quickshell.Services.Mpris
import QtQuick



QtObject {
    id: root

    required property MprisPlayer rawPlayer
    property string trackTitle: ""
    property string trackArtist: ""
    property string trackArtUrl: ""
    property bool lengthSupported: false
    property real length: 0 
    property bool loopSupported: false
    property bool shuffleSupported: false

    function registerLength() {
        if (rawPlayer.lengthSupported && rawPlayer.length < 9223372036854) {
            root.lengthSupported = true
            root.length = root.rawPlayer.length
        }
    }

    readonly property Connections connections: Connections {
        target: root.rawPlayer

        function onTrackChanged() {
            if (root.rawPlayer.trackTitle !== root.trackTitle || root.rawPlayer.trackArtist !== root.trackArtist) {
                root.trackTitle = root.rawPlayer.trackTitle
                root.trackArtist = root.rawPlayer.trackArtist
                root.trackArtUrl = root.rawPlayer.trackArtUrl

                root.lengthSupported = false
                root.length = 0

                root.loopSupported = root.rawPlayer.loopSupported
                root.shuffleSupported = root.rawPlayer.shuffleSupported
            }
        }

        function onTrackTitleChanged() {
            root.trackTitle = root.rawPlayer.trackTitle
        }

        function onTrackArtistChanged() {
            root.trackArtist = root.rawPlayer.trackArtist
        }

        function onTrackArtUrlChanged() {
            if (root.rawPlayer.trackArtUrl !== "") root.trackArtUrl = root.rawPlayer.trackArtUrl
        }

        function onLengthChanged() {
            registerLength()
        }

        function onLoopSupportedChanged() {
            if (root.rawPlayer.loopSupported) root.loopSupported = true
        }

        function onShuffleSupportedChanged() {
            if (root.rawPlayer.shuffleSupported) root.shuffleSupported = true
        }
    }

    Component.onCompleted: () => {
        root.trackTitle = root.rawPlayer.trackTitle
        root.trackArtist = root.rawPlayer.trackArtist
        root.trackArtUrl = root.rawPlayer.trackArtUrl

        registerLength()

        root.loopSupported = root.rawPlayer.loopSupported
        root.shuffleSupported = root.rawPlayer.shuffleSupported
    }
}