pragma Singleton

import Quickshell
import QtQuick

import qs.resources



Singleton {
    id: root

    property ModuleArea currentOpenPanel: null

    readonly property bool settingsOpen: persistent.settingsOpen

    PersistentProperties {
        id: persistent
        reloadableId: "panelPersist"

        property bool settingsOpen: false
    }

    function openPanel(panel: ModuleArea): void {
        currentOpenPanel = panel
        panelFocusGained()
    }

    function closePanel(panel: ModuleArea): void {
        if (currentOpenPanel === panel) currentOpenPanel = null
    }

    function forceClosePanel() : void{
        currentOpenPanel = null
    }

    function panelFocusGained(): void {
        hideTimer.stop()
    }

    function panelFocusLost(): void {
        hideTimer.restart()
    }

    function toggleSettingsOpen(): void { persistent.settingsOpen = !persistent.settingsOpen }
    function setSettingsOpen(isOpen: bool): void { persistent.settingsOpen = isOpen }

    Timer {
        id: hideTimer
        interval: 250

        onTriggered: () => {
            PanelManager.forceClosePanel()
        }
    }
}