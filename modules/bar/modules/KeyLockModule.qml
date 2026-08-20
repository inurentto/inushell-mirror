import Quickshell
import QtQuick

import ShellExtensions

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

            backgroundColor: KeyLock.capsLock ? Config.theme.getAccent() : Config.theme.getBackground1()

            TintedIcon {
                source: Icons.getIcon( "caps-lock-on" )
                tint: KeyLock.capsLock ? Config.theme.getBackground0() : Config.theme.getForeground0()
            }
        },
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.NoButton

            enabled: KeyLock.numLock

            aspectRatio: 1

            backgroundColor: KeyLock.numLock ? Config.theme.getAccent() : Config.theme.getBackground1()

            TintedIcon {
                source: Icons.getIcon( "num-lock-on" )
                tint: KeyLock.numLock ? Config.theme.getBackground0() : Config.theme.getForeground0()
            }
        }
    ]
}