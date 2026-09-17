import Quickshell
import QtQuick

import ShellExtensions

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.bar
import qs.resources



Module {
    id: root

    areas: [
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.NoButton

            enabled: KeyLock.capsLock

            aspectRatio: 1

            backgroundColor: KeyLock.capsLock ? Settings.palette.accent : Settings.palette.background1

            TintedIcon {
                source: Icons.getIcon"caps-lock-on")
                tint: KeyLock.capsLock ? Settings.palette.background0 : Settings.palette.foreground0
            }
        },
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.NoButton

            enabled: KeyLock.numLock

            aspectRatio: 1

            backgroundColor: KeyLock.numLock ? Settings.palette.accent : Settings.palette.background1

            TintedIcon {
                source: Icons.getIcon"num-lock-on")
                tint: KeyLock.numLock ? Settings.palette.background0 : Settings.palette.foreground0
            }
        }
    ]
}