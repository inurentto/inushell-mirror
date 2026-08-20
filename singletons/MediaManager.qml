pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

import qs.singletons
import qs.resources



Singleton {
    id: root

    readonly property list<MediaPlayer> players: []
    readonly property MediaPlayer activePlayer: players[activePlayerIndex] ?? players[0] ?? null
    
    readonly property int activePlayerIndex: _activePlayerIndex
    property int _activePlayerIndex: 0

    property list<string> playerPriority: [
        "spotify"
    ]

    function setActivePlayer(newIndex: int): void {
        _activePlayerIndex = Util.clamp(newIndex, 0, players.length - 1)
    }

    function incrementActivePlayer(increment: int): void {
        _activePlayerIndex = Util.mod(_activePlayerIndex + increment, players.length)
    }

    function getPlayerPriority(player: MediaPlayer): int {
        return playerPriority.indexOf(player.rawPlayer.identity.toLowerCase())
    }

    function getHighestPriorityPlayer( ): MediaPlayer {
        var highestPriority = -1
        var highestPriorityPlayer = null
        players.forEach((player) => {
            var priority = getPlayerPriority(player)
            if (priority > highestPriority) {
                highestPriority = priority
                highestPriorityPlayer = player
            }
        } )

        return highestPriorityPlayer
    }

    function createMediaPlayerWrapper(mprisPlayer: MprisPlayer): MediaPlayer {
        const mediaPlayer = mediaPlayerHolder.createObject(root, {
            rawPlayer: mprisPlayer
        })

        root.players.push(mediaPlayer)

        return mediaPlayer
    }

    Connections {
        target: Mpris.players

        function onObjectInsertedPost(object: MprisPlayer, index: int) {
            const mediaPlayer = createMediaPlayerWrapper(object)
            if (activePlayer === null || getPlayerPriority(mediaPlayer) > getPlayerPriority(activePlayer)) {
                setActivePlayer(index)
            }
        }

        function onObjectRemovedPost(object: MprisPlayer, index: int) {
            root.players.splice(index, 1)

            setActivePlayer(players.indexOf(getHighestPriorityPlayer()))
        }
    }

    Component.onCompleted: ( ) => {
        for (let index = 0; index < Mpris.players.values.length; index++) {
            createMediaPlayerWrapper(Mpris.players.values[index])
        }

        setActivePlayer( players.indexOf( getHighestPriorityPlayer( ) ) )
    }

    Component {
        id: mediaPlayerHolder

        MediaPlayer {}
    }
}