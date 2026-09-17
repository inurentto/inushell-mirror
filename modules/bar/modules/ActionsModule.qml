import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.bar
import qs.resources



Module {
    id: root

    onClicked: () => {
        PanelManager.toggleSettingsOpen()
    }

    areas: [
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.LeftButton

            aspectRatio: 1

            TintedIcon {
                source: Icons.getIcon("distributor-logo-nixos")
            }
        }
    ]
}