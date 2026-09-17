import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.components
import qs.components.controls



FloatingWindow {
    id: root

    color: Settings.palette.background0

    WrapperItem {
        margin: Settings.spacing.big

        Column {
            spacing: Settings.spacing.big

            StyledText {
                text: "Shader Test"
            }

            Image {
                id: shaderTestImage

                source: Icons.getIcon("auth-sim-locked-symbolic")

                layer.enabled: true
                layer.effect: ShaderEffect {
                    property color color: Settings.palette.foreground0
                    fragmentShader: "TestShader.frag.qsb"
                    blending: true
                }
            }

            StyledText {
                text: "Buttons"
            }

            Column {
                spacing: Settings.spacing.big

                Row {
                    spacing: Settings.spacing.big

                    StyledButton {
                        text: "button"

                        onClicked: () => {
                            console.log("clicked")
                        }
                    }
                    StyledButton {
                        enabled: false
                        text: "button"
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledButton {
                        text: "icon"
                        icon: Icons.getIcon("preferences-system-symbolic")
                    }
                    StyledButton {
                        enabled: false
                        text: "icon"
                        icon: Icons.getIcon("preferences-system-symbolic")
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledButton {
                        flat: true
                        text: "flat"
                    }
                    StyledButton {
                        enabled: false
                        flat: true
                        text: "flat"
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledButton {
                        id: toggleButtonNoIcon
                        checkable: true
                        text: "button toggle"
                    }
                    StyledButton {
                        enabled: false
                        checkable: true
                        checked: toggleButtonNoIcon.checked
                        text: "button toggle"
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledButton {
                        id: toggleButtonIcon
                        checkable: true
                        text: "icon toggle"
                        icon: Icons.getIcon("preferences-system-symbolic")
                    }
                    StyledButton {
                        enabled: false
                        checkable: true
                        checked: toggleButtonIcon.checked
                        text: "icon toggle"
                        icon: Icons.getIcon("preferences-system-symbolic")
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledButton {
                        id: toggleButtonFlat
                        flat: true
                        checkable: true
                        text: "flat toggle"
                    }
                    StyledButton {
                        enabled: false
                        checkable: true
                        checked: toggleButtonFlat.checked
                        flat: true
                        text: "flat toggle"
                    }
                }
            }

            StyledText {
                text: "Button Groups"
            }

            Row {
                spacing: Settings.spacing.big

                Column {
                    spacing: Settings.spacing.small

                    StyledButtonGroup {
                        id: columnButtonGroup
                        exclusive: true
                    }

                    StyledButton {
                        text: "1"
                        checkable: true
                        checked: true

                        buttonGroup: columnButtonGroup
                    }
                    StyledButton {
                        text: "2"
                        checkable: true

                        buttonGroup: columnButtonGroup
                    }
                    StyledButton {
                        text: "3"
                        checkable: true

                        buttonGroup: columnButtonGroup
                    }
                }

                RowLayout {
                    width: 500

                    spacing: Settings.spacing.small

                    StyledButtonGroup {
                        id: rowButtonGroup
                        exclusive: false
                    }

                    StyledButton {
                        Layout.fillWidth: true

                        text: "1"
                        checkable: true
                        checked: true

                        buttonGroup: rowButtonGroup
                    }
                    StyledButton {
                        Layout.fillWidth: true

                        text: "2"
                        checkable: true

                        buttonGroup: rowButtonGroup
                    }
                    StyledButton {
                        Layout.fillWidth: true

                        text: "3"
                        checkable: true

                        buttonGroup: rowButtonGroup
                    }
                }
            }

            StyledText {
                text: "Switches"
            }

            Column {
                spacing: Settings.spacing.big

                Row {
                    spacing: Settings.spacing.big

                    StyledSwitch {
                        id: switchNoText
                    }
                    StyledSwitch {
                        enabled: false
                        checked: switchNoText.checked
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledSwitch {
                        id: switchText
                        text: "switch"
                    }
                    StyledSwitch {
                        text: "switch"
                        enabled: false
                        checked: switchText.checked
                    }
                }
            }

            StyledText {
                text: "Sliders"
            }

            Row {
                spacing: Settings.spacing.big

                Column {
                    spacing: Settings.spacing.big

                    StyledSlider {
                        onMoved: (movedValue) => { value = movedValue; disabledFilledSlider.value = movedValue }
                    }
                    StyledSlider {
                        filled: false

                        onMoved: (movedValue) => { value = movedValue; disabledSlider.value = movedValue }
                    }
                    StyledSlider {
                        flip: true

                        onMoved: (movedValue) => { value = movedValue; disabledFlippedFilledSlider.value = movedValue }
                    }
                    StyledSlider {
                        filled: false
                        flip: true

                        onMoved: (movedValue) => { value = movedValue; disabledFlippedSlider.value = movedValue }
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledSlider {
                        vertical: true

                        onMoved: (movedValue) => { value = movedValue; disabledVerticalFilledSlider.value = movedValue }
                    }
                    StyledSlider {
                        vertical: true
                        filled: false

                        onMoved: (movedValue) => { value = movedValue; disabledVerticalSlider.value = movedValue }
                    }
                    StyledSlider {
                        vertical: true
                        flip: true

                        onMoved: (movedValue) => { value = movedValue; disabledFlippedFilledVerticalSlider.value = movedValue }
                    }
                    StyledSlider {
                        vertical: true
                        filled: false
                        flip: true

                        onMoved: (movedValue) => { value = movedValue; disabledFlippedVerticalSlider.value = movedValue }
                    }
                }

                Column {
                    spacing: Settings.spacing.big

                    StyledSlider {
                        id: disabledFilledSlider
                        enabled: false
                    }
                    StyledSlider {
                        id: disabledSlider
                        enabled: false
                        filled: false
                    }
                    StyledSlider {
                        id: disabledFlippedFilledSlider
                        enabled: false
                        flip: true
                    }
                    StyledSlider {
                        id: disabledFlippedSlider
                        enabled: false
                        filled: false
                        flip: true
                    }
                }
                Row {
                    spacing: Settings.spacing.big

                    StyledSlider {
                        id: disabledVerticalFilledSlider
                        enabled: false
                        vertical: true
                    }
                    StyledSlider {
                        id: disabledVerticalSlider
                        enabled: false
                        vertical: true
                        filled: false
                    }
                    StyledSlider {
                        id: disabledFlippedFilledVerticalSlider
                        enabled: false
                        vertical: true
                        flip: true
                    }
                    StyledSlider {
                        id: disabledFlippedVerticalSlider
                        enabled: false
                        vertical: true
                        filled: false
                        flip: true
                    }
                }
            }

            StyledText {
                text: "Text Fields"
            }

            Row {
                spacing: Settings.spacing.big

                StyledTextField {
                    id: enabledTextField
                }
                StyledTextField {
                    text: enabledTextField.text
                    enabled: false
                }
            }
        }
    }
}