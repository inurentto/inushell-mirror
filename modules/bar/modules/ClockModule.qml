import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.controls
import qs.widgets.bar
import qs.resources



Module {
    id: root

    property int selectedMonth: TimeManager.rawDateTime.getMonth()
    property int selectedYear: TimeManager.rawDateTime.getFullYear()

    property bool hovered: false
    property bool toggled: false

    onClicked: () => {
        if (Settings.raw.modules.clock.displayBehavior === Settings.ClockModuleDisplayBehavior.Toggle) toggled = !toggled
    }

    onEntered: () => {
        hovered = true
    }
    onExited: () => {
        hovered = false
    }

    areas: [
        ModuleArea {
            id: dateArea

            window: root.window
            acceptedButtons: Settings.raw.modules.clock.displayBehavior === Settings.ClockModuleDisplayBehavior.Toggle ? Qt.LeftButton : Qt.NoButton

            panelContent: Component {
                ColumnLayout {
                    spacing: Settings.spacing.medium

                    RowLayout {
                        spacing: Settings.spacing.small

                        Button {
                            topRightCornerRadius: 0
                            bottomRightCornerRadius: 0

                            onClicked: () => {
                                root.selectedYear--
                            }

                            Text {
                                text: "<<"
                            }
                        }

                        Button {
                            topLeftCornerRadius: 0
                            bottomLeftCornerRadius: 0

                            onClicked: () => {
                                const prevMonth = root.selectedMonth - 1
                                if (prevMonth < 0) {
                                    root.selectedYear--
                                    root.selectedMonth = 11
                                } else {
                                    root.selectedMonth = prevMonth
                                }
                            }

                            Text {
                                text: "<"
                            }
                        }

                        Text {
                            text: {
                                const date = new Date(selectedYear, selectedMonth)
                                return Qt.formatDateTime(date, "MMMM, yyyy")
                            }
                            horizontalAlignment: Text.AlignHCenter

                            Layout.fillWidth: true
                        }

                        Button {
                            topRightCornerRadius: 0
                            bottomRightCornerRadius: 0

                            onClicked: () => {
                                const nextMonth = root.selectedMonth + 1
                                if (nextMonth > 11) {
                                    root.selectedYear++
                                    root.selectedMonth = 0
                                } else {
                                    root.selectedMonth = nextMonth
                                }
                            }

                            Text {
                                text: ">"
                            }
                        }

                        Button {
                            topLeftCornerRadius: 0
                            bottomLeftCornerRadius: 0

                            onClicked: () => {
                                root.selectedYear++
                            }

                            Text {
                                text: ">>"
                            }
                        }
                    }

                    GridLayout {
                        columns: 2

                        DayOfWeekRow {
                            locale: grid.locale

                            spacing: Settings.spacing.small

                            delegate: Text {
                                required property string shortName

                                text: shortName
                                horizontalAlignment: Text.AlignHCenter
                            }

                            Layout.column: 1
                            Layout.fillWidth: true
                        }

                        WeekNumberColumn {
                            month: grid.month
                            year: grid.year
                            locale: grid.locale

                            spacing: Settings.spacing.small

                            delegate: Text {
                                required property int weekNumber

                                text: weekNumber
                                verticalAlignment: Text.AlignVCenter
                            }

                            Layout.fillHeight: true
                        }

                        MonthGrid {
                            id: grid
                            month: root.selectedMonth
                            year: root.selectedYear

                            spacing: Settings.spacing.small

                            delegate: Button {
                                required property var model

                                opacity: grid.month !== model.month ? 0.5: 1

                                backgroundColor: model.today ? Settings.palette.accent : Settings.palette.background1

                                Text {
                                    text: model.day >= 10 ? model.day : "0" + model.day
                                    color: model.today ? Settings.palette.background0 : Settings.palette.foreground0
                                }
                            }

                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }
            }

            Text {
                text: {
                    switch (Settings.raw.modules.clock.displayBehavior) {
                        case Settings.ClockModuleDisplayBehavior.Full: return TimeManager.formattedTime + " - " + TimeManager.formattedDate
                        case Settings.ClockModuleDisplayBehavior.Hover: return !root.hovered ? TimeManager.formattedTime : TimeManager.formattedDate
                        case Settings.ClockModuleDisplayBehavior.Toggle: return !root.toggled ? TimeManager.formattedTime : TimeManager.formattedDate
                    }
                }
                verticalAlignment: Text.AlignVCenter
            }
        }
    ]

    Connections {
        target: Settings.raw.modules.clock

        function onDisplayBehaviorChanged() {
            if (Settings.raw.modules.clock.displayBehavior !== Settings.ClockModuleDisplayBehavior.Toggle) toggled = false
            dateArea.acceptedButtons = Settings.raw.modules.clock.displayBehavior === Settings.ClockModuleDisplayBehavior.Toggle ? Qt.LeftButton : Qt.NoButton
        }
    }
}