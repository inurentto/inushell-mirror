pragma Singleton

import Quickshell
import QtQuick

import qs.resources



Singleton {
    id: root

    property ModuleArea currentOpenPanel: null

    function openPanel( panel: ModuleArea ) {
        currentOpenPanel = panel
        panelFocusGained( )
    }

    function closePanel( panel: ModuleArea ) {
        if ( currentOpenPanel === panel ) currentOpenPanel = null
    }

    function forceClosePanel( ) {
        currentOpenPanel = null
    }

    function panelFocusGained( ) {
        hideTimer.stop( )
    }

    function panelFocusLost( ) {
        hideTimer.restart( )
    }

    Timer {
        id: hideTimer
        interval: 250

        onTriggered: ( ) => {
            PanelManager.forceClosePanel( )
        }
    }
}