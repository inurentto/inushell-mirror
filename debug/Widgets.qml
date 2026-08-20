import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.singletons

import qs.widgets
import qs.widgets.controls
import qs.widgets.bar
import qs.widgets.notifications
import qs.resources




FloatingWindow {
    id: root

    readonly property color _color: Config.theme.getBackground0()
    color: Qt.rgba(
        _color.r,
        _color.g,
        _color.b,
        0
    )

    Item {
        x: 10
        y: 10

        implicitWidth: parent.width - 10 * 2
        implicitHeight: parent.height - 10 * 2

        ColumnLayout {
            RowLayout {
                Switch {
                    id: disableToggle

                    isToggled: false
                }

                Text {
                    text: "Disable Controls"
                }
            }

            Text {
                text: "Buttons"
            }

            RowLayout {
                Button {
                    enabled: !disableToggle.isToggled

                    Text {
                        text: "Button"
                    }
                }
                Button {
                    enabled: !disableToggle.isToggled
                    toggleable: true
                    isToggled: true

                    Text {
                        text: "Toggle"
                    }
                }
            }

            Text {
                text: "Switches"
            }

            RowLayout {
                Switch {
                    enabled: !disableToggle.isToggled
                }
            }

            Text {
                text: "Sliders & Progress Bars"
            }

            RowLayout {
                ColumnLayout {
                    Slider {
                        value: progressBar.value
                        enabled: !disableToggle.isToggled

                        snapPoints: [ 0.25, 0.5, 0.75 ]

                        onMoved: (value) => {
                            progressBar.value = value
                        }
                    }
                    Slider {
                        value: progressBarFlipped.value
                        enabled: !disableToggle.isToggled
                        flip: true

                        snapPoints: [ 0.25, 0.5, 0.75 ]

                        onMoved: (value) => {
                            progressBarFlipped.value = value
                        }
                    }
                }
                ColumnLayout {
                    Slider {
                        value: progressBarNoPercentage.value
                        enabled: !disableToggle.isToggled
                        filled: true

                        snapPoints: [ 0.25, 0.5, 0.75 ]

                        onMoved: (value) => {
                            progressBarNoPercentage.value = value
                        }
                    }
                    Slider {
                        value: progressBarNoPercentageFlipped.value
                        enabled: !disableToggle.isToggled
                        filled: true
                        flip: true

                        snapPoints: [ 0.25, 0.5, 0.75 ]

                        onMoved: (value) => {
                            progressBarNoPercentageFlipped.value = value
                        }
                    }
                }

                Slider {
                    value: progressBarVertical.value
                    enabled: !disableToggle.isToggled
                    vertical: true

                    snapPoints: [ 0.25, 0.5, 0.75 ]

                    onMoved: (value) => {
                        progressBarVertical.value = value
                    }
                }
                Slider {
                    value: progressBarVerticalFlipped.value
                    enabled: !disableToggle.isToggled
                    vertical: true
                    flip: true

                    snapPoints: [ 0.25, 0.5, 0.75 ]

                    onMoved: (value) => {
                        progressBarVerticalFlipped.value = value
                    }
                }
                Slider {
                    value: progressBarVerticalNoPercentage.value
                    enabled: !disableToggle.isToggled
                    vertical: true
                    filled: true

                    snapPoints: [ 0.25, 0.5, 0.75 ]

                    onMoved: (value) => {
                        progressBarVerticalNoPercentage.value = value
                    }
                }
                Slider {
                    value: progressBarVerticalNoPercentageFlipped.value
                    enabled: !disableToggle.isToggled
                    vertical: true
                    filled: true
                    flip: true

                    snapPoints: [ 0.25, 0.5, 0.75 ]

                    onMoved: (value) => {
                        progressBarVerticalNoPercentageFlipped.value = value
                    }
                }
            }
            RowLayout {
                ColumnLayout {
                    ProgressBar {
                        id: progressBar
                        implicitHeight: 32
                    }
                    ProgressBar {
                        id: progressBarFlipped
                        implicitHeight: 32
                        flip: true
                    }
                }
                ColumnLayout {
                    ProgressBar {
                        id: progressBarNoPercentage
                        showPercentage: false
                    }
                    ProgressBar {
                        id: progressBarNoPercentageFlipped
                        showPercentage: false
                        flip: true
                    }
                }

                ProgressBar {
                    id: progressBarVertical
                    implicitWidth: 32
                    vertical: true
                }
                ProgressBar {
                    id: progressBarVerticalFlipped
                    implicitWidth: 32
                    vertical: true
                    flip: true
                }

                ProgressBar {
                    id: progressBarVerticalNoPercentage
                    showPercentage: false
                    vertical: true
                }
                ProgressBar {
                    id: progressBarVerticalNoPercentageFlipped
                    showPercentage: false
                    vertical: true
                    flip: true
                }
            }

            Text {
                text: "Button Bar"
            }
            ButtonBar {
                enabled: !disableToggle.isToggled

                ButtonBarItem {
                    Text {
                        text: "Hi"
                    }
                }
                ButtonBarItem {
                    Text {
                        text: "Hi"
                    }
                }
                ButtonBarItem {
                    Text {
                        text: "Hi"
                    }
                }
            }
            ButtonBar {
                id: buttonBar
                toggleable: true

                ButtonBarItem {
                    Text {
                        text: "Hi"
                    }
                }
                ButtonBarItem {
                    Text {
                        text: "Hi"
                    }
                }
                ButtonBarItem {
                    Text {
                        text: "Hi"
                    }
                }

                enabled: !disableToggle.isToggled
            }
            Text {
                text: "Selected: " + buttonBar.selectedIndex
            }

            Text {
                text: "Text Field"
            }
            TextField {
                implicitWidth: 512
            }

            Text {
                text: "Bar Module"
            }
            Module {
                implicitHeight: 36

                areas: [
                    ModuleArea {
                        Rectangle {
                            implicitWidth: 32
                            implicitHeight: 32
                            
                            color: "red"
                        }
                    },

                    ModuleArea {
                        Rectangle {
                            implicitWidth: 32
                            implicitHeight: 32

                            color: "blue"
                        }
                    }
                ]
            }
        }
    }
}