import Quickshell.Hyprland
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

    areas: updateWorkspaces(HyprlandManager.workspaces.values)

    onClicked: (mouse, moduleArea) => moduleArea.workspace.activate()

    Component {
        id: workspaceModuleAreaComponent

        ModuleArea {
            window: root.window

            property var workspace

            backgroundColor: {
                if (workspace.urgent) return Settings.palette.orange
                else if (workspace.focused) return Settings.palette.accent
                else if (workspace.active) return Settings.palette.background2
                else Settings.palette.background1
            }
            backgroundHoverColor: {
                if (workspace.focused) return Settings.palette.accent
                else Settings.palette.background2
            }
            backgroundPressColor: {
                if (workspace.focused) return Settings.palette.accent
                else return Settings.palette.background0
            }

            cursorShape: workspace.focused ? Qt.ArrowCursor : Qt.PointingHandCursor

            aspectRatio: 1

            panelContent: Component {
                Text {
                    text: "Workspace: " + workspace.name
                }
            }

            Text {
                id: workspaceLabel

                anchors.centerIn: parent

                text: workspace.name
                color: {
                    if (workspace.focused || workspace.urgent) return Settings.palette.background0
                    else return Settings.palette.foreground0
                }
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                Behavior on color {
                    ColorAnimation {
                        duration: Settings.animationSpeed.fast
                        easing.type: Settings.animationEasing.easeOut
                    }
                }
            }
        }
    }

    function updateWorkspaces(workspaces): list<ModuleArea> {
        const workspaceModuleAreas = []
        for (let index = 0; index < workspaces.length; index++) {
            if (workspaces[index].id < 0) continue

            const workspaceModuleArea = workspaceModuleAreaComponent.createObject(root, {
                workspace: workspaces[index]
            })

            workspaceModuleAreas.push(workspaceModuleArea)
        }

        return workspaceModuleAreas
    }
}