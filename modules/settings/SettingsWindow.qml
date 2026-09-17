import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.services
import qs.singletons
import qs.components
import qs.components.controls
import qs.modules.settings.pages



Scope {
    LazyLoader {
        activeAsync: true //Settings.interfaceOpen

        FloatingWindow {
            id: window
            title: "Settings"

            minimumSize: Qt.size(1000, 600)

            color: Settings.palette.background0

            onClosed: () => Settings.interfaceOpen = false

            StyledButtonGroup {
                id: categoryButtonGroup
                exclusive: true
            }

            RowLayout {
                anchors.fill: parent

                spacing: 0

                WrapperRectangle {
                    Layout.fillHeight: true

                    implicitWidth: 300

                    margin: Settings.spacing.big

                    color: Settings.palette.background1

                    ColumnLayout {
                        spacing: Settings.spacing.big

                        StyledText {
                            text: "Settings"
                            font.pointSize: Settings.fontSize.bigTitle
                            font.bold: true
                        }

                        Separator {
                            Layout.fillWidth: true
                        }

                        ScrollView {
                            id: categoryView

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ScrollBar.vertical: ScrollBar {}

                            ColumnLayout {
                                spacing: Settings.spacing.big

                                StyledText {
                                    text: "Appearance"
                                    font.pointSize: Settings.fontSize.smallTitle
                                    font.bold: true
                                }

                                ColumnLayout {
                                    spacing: Settings.spacing.small

                                    StyledButton {
                                        id: appearanceThemesCategory

                                        Layout.fillWidth: true

                                        implicitWidth: categoryView.width

                                        checkable: true
                                        checked: true
                                        buttonGroup: categoryButtonGroup

                                        text: "Themes"
                                        icon: Icons.getIcon("preferences-desktop-wallpaper-symbolic")
                                    }
                                }

                                StyledText {
                                    text: "Bar Modules"
                                    font.pointSize: Settings.fontSize.smallTitle
                                    font.bold: true
                                }

                                ColumnLayout {
                                    spacing: Settings.spacing.small

                                    StyledButton {
                                        id: barModulesClockCategory

                                        Layout.fillWidth: true

                                        implicitWidth: categoryView.width

                                        checkable: true
                                        buttonGroup: categoryButtonGroup

                                        text: "Clock"
                                        icon: Icons.getIcon("clock-applet-symbolic")
                                    }
                                }
                            }
                        }
                    }
                }

                WrapperItem {
                    id: settingsWrapperItem

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    margin: Settings.spacing.big

                    ColumnLayout {
                        spacing: Settings.spacing.big

                        StyledText {
                            text: categoryButtonGroup.checkedButtons[0]?.text ?? "???"
                            font.pointSize: Settings.fontSize.bigTitle
                            font.bold: true
                        }

                        Separator {
                            Layout.fillWidth: true
                        }

                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ScrollBar.vertical: ScrollBar {}

                            ThemesPage { implicitWidth: settingsWrapperItem.width - settingsWrapperItem.margin * 2; visible: categoryButtonGroup.checkedButtons[0] == appearanceThemesCategory }
                            ClockPage { implicitWidth: settingsWrapperItem.width - settingsWrapperItem.margin * 2; visible: categoryButtonGroup.checkedButtons[0] == barModulesClockCategory }
                        }
                    }
                }
            }
        }
    }
}