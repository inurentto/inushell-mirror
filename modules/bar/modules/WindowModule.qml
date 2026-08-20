import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.widgets
import qs.widgets.bar
import qs.resources




Module {
    id: root

    visible: HyprlandManager.activeToplevel && HyprlandManager.activeToplevel?.wayland?.activated

    areas: [
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.NoButton

            panelContent: Component {
                Text {
                    text: "Class: " + HyprlandManager.activeToplevel?.wayland?.appId
                }
            }

            RowLayout {
                spacing: Config.theme.spacing.big
                
                IconImage {
                    source: Icons.getAppIcon(HyprlandManager.activeToplevel?.wayland?.appId)
                    implicitSize: 16

                    visible: source !== ""
                }

                Text {
                    text: HyprlandManager.activeToplevel?.title ?? ""
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    ]
}