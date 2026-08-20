import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

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
                if (workspace.urgent) return Config.theme.getOrange()
                else if (workspace.focused) return Config.theme.getAccent()
                else if (workspace.active) return Config.theme.getBackground2()
                else Config.theme.getBackground1()
            }
            backgroundHoverColor: {
                if (workspace.focused) return Config.theme.getAccent()
                else Config.theme.getBackground2()
            }
            backgroundPressColor: {
                if (workspace.focused) return Config.theme.getAccent()
                else return Config.theme.getBackground0()
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
                    if (workspace.focused || workspace.urgent) return Config.theme.getBackground0()
                    else return Config.theme.getForeground0()
                }
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                Behavior on color {
                    ColorAnimation {
                        duration: Config.theme.animationSpeed.fast
                        easing.type: Config.theme.easingType
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