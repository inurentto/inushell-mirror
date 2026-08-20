import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Effects

import qs.singletons
import qs.widgets
import qs.widgets.controls
import qs.widgets.bar
import qs.resources




Module {
    id: root

    areas: updateSystemTray(SystemTray.items.values)

    onClicked: (mouse, area, index) => {
        let systemTrayItem = SystemTray.items.values[index]
        if (mouse.button === Qt.LeftButton) systemTrayItem.activate()
        else if (mouse.button === Qt.RightButton) systemTrayItem.secondaryActivate()
    }

    Component {
        id: systemTrayItemModuleAreaComponent

        ModuleArea {
            window: root.window

            property var systemTrayItem

            acceptedButtons: Qt.LeftButton | Qt.RightButton

            aspectRatio: 1

            panelContent: Component {
                ColumnLayout {
                    id: panelRoot

                    property list<QsMenuHandle> parents: []
                    property QsMenuHandle currentMenu: systemTrayItem.menu
                    
                    spacing: Config.theme.spacing.normal

                    Item {
                        id: menuEntryContainer

                        Layout.fillWidth: true

                        implicitWidth: childrenRect.width
                        implicitHeight: childrenRect.height

                        ColumnLayout {
                            id: columnLayout

                            implicitWidth: parent.width

                            spacing: Config.theme.spacing.small

                            Loader {
                                property var index: -1
                                property var modelData: {
                                    "text": "Back",
                                    "enabled": true,
                                    "hasChildren": false
                                }

                                sourceComponent: buttonDelegate

                                visible: panelRoot.parents.length > 0
                            }

                            Loader {
                                sourceComponent: separatorDelegate

                                visible: panelRoot.parents.length > 0
                            }

                            Repeater {
                                id: repeater

                                model: menuOpener.children

                                delegate: Loader {
                                    required property int index
                                    required property var modelData

                                    sourceComponent: {
                                        if (modelData.isSeparator) return separatorDelegate
                                        else buttonDelegate
                                    }
                                }
                            }

                            Component {
                                id: buttonDelegate

                                Button {
                                    id: button

                                    implicitWidth: Math.max(
                                        menuEntryContainer.width,
                                        buttonContent.implicitWidth + button.leftPadding + button.rightPadding
                                    )

                                    enabled: {
                                        modelData.enabled
                                    }

                                    propagateComposedEvents: true

                                    topPadding: 4
                                    bottomPadding: 4

                                    topLeftCornerRadius: {
                                        if (index === -1) return Config.theme.cornerRadius.normal
                                        if (index === 0) return Config.theme.cornerRadius.normal

                                        const lastEntry = menuOpener.children.values[index - 1]
                                        if (lastEntry && lastEntry.isSeparator) return Config.theme.cornerRadius.normal

                                        return Config.theme.cornerRadius.small
                                    }
                                    topRightCornerRadius: {
                                        if (index === -1) return Config.theme.cornerRadius.normal
                                        if (index === 0) return Config.theme.cornerRadius.normal

                                        const lastEntry = menuOpener.children.values[index - 1]
                                        if (lastEntry && lastEntry.isSeparator) return Config.theme.cornerRadius.normal

                                        return Config.theme.cornerRadius.small
                                    }
                                    bottomLeftCornerRadius: {
                                        if (index === -1) return Config.theme.cornerRadius.normal
                                        if (index === repeater.count - 1) return Config.theme.cornerRadius.normal

                                        const nextEntry = menuOpener.children.values[index + 1]
                                        if (nextEntry && nextEntry.isSeparator) return Config.theme.cornerRadius.normal 
                                        
                                        return Config.theme.cornerRadius.small
                                    }
                                    bottomRightCornerRadius: {
                                        if (index === -1) return Config.theme.cornerRadius.normal
                                        if (index === repeater.count - 1) return Config.theme.cornerRadius.normal

                                        const nextEntry = menuOpener.children.values[index + 1]
                                        if (nextEntry && nextEntry.isSeparator) return Config.theme.cornerRadius.normal 
                                        
                                        return Config.theme.cornerRadius.small
                                    }

                                    onClicked: () => {
                                        if (index === -1) {
                                            const parentMenu = panelRoot.parents.pop()
                                            panelRoot.currentMenu = parentMenu
                                        } else if (modelData.hasChildren) {
                                            panelRoot.parents.push(panelRoot.currentMenu)
                                            panelRoot.currentMenu = modelData
                                        } else {
                                            modelData.triggered()
                                        }
                                    }

                                    RowLayout {
                                        id: buttonContent

                                        spacing: Config.theme.spacing.normal

                                        TintedIcon {
                                            source: index === -1 ? Icons.getIcon("arrow-left") : modelData.icon
                                            implicitSize: 12
                                        }

                                        Text {
                                            text: modelData.text
                                            font.pointSize: Config.theme.textSize.small
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        TintedIcon {
                                            source: Icons.getIcon("arrow-right")
                                            implicitSize: 12

                                            visible: modelData.hasChildren
                                        }
                                    }
                                }
                            }

                            Component {
                                id: separatorDelegate
                                
                                Separator {
                                    anchors.centerIn: parent

                                    implicitWidth: menuEntryContainer.width
                                    implicitHeight: 13
                                }
                            }
                        }
                    }

                    QsMenuOpener {
                        id: menuOpener
                        menu: panelRoot.currentMenu
                    }
                }
            }

            IconImage {
                source: Icons.getTrayIcon(systemTrayItem.id, systemTrayItem.icon)
            }
        }
    }

    function updateSystemTray(systemTrayItems): list<ModuleArea> {
        const systemTrayItemModuleAreas = []
        for (let index = 0; index < systemTrayItems.length; index++) {
            const systemTrayItemModuleArea = systemTrayItemModuleAreaComponent.createObject(root, {
                systemTrayItem: systemTrayItems[index]
            })

            systemTrayItemModuleAreas.push(systemTrayItemModuleArea)
        }

        return systemTrayItemModuleAreas
    }
}