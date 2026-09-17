import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Polkit
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.controls



Scope {
	id: root

    LazyLoader {
        id: interfaceLoader

        activeAsync: false

        PanelWindow {
            id: interfaceWindow

            anchors {
                bottom: true
            }

            exclusionMode: ExclusionMode.Ignore

            color: "transparent"

            mask: Region { item: contentContainer }

            implicitWidth: Math.min( Math.max( message.width + Settings.spacing.medium * 2 + Settings.spacing.big * 2, 500), 1000)
            implicitHeight: screen.height / 2

            WlrLayershell.layer: WlrLayer.Overlay

            focusable: true
            WlrLayershell.keyboardFocus: polkitAgent.isActive ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

            visible: true

            Component.onCompleted: () => {
                passwordInput.forceActiveFocus()
                passwordInput.text = ""

                openAnimation.start()
            }

            function submit() {
                polkitAgent.flow?.submit(passwordInput.text)
                passwordInput.text = ""
                passwordInput.forceActiveFocus()

                closeAnimation.start()
            }

            function cancel() {
                polkitAgent.flow?.cancelAuthenticationRequest()
                passwordInput.text = ""

                closeAnimation.start()
            }

            ClippingWrapperRectangle {
                id: contentContainer

                property real yOffset: interfaceWindow.height

                x: Settings.spacing.big
                y: interfaceWindow.height - height + yOffset - Settings.spacing.big

                implicitWidth: interfaceWindow.width - border.width * 2 - Settings.spacing.big * 2

                topMargin: Settings.spacing.medium
                bottomMargin: Settings.spacing.medium
                leftMargin: Settings.spacing.medium
                rightMargin: Settings.spacing.medium

                color: Settings.palette.background0

                radius: Settings.radius.big

                ParallelAnimation {
                    id: openAnimation
                    PropertyAnimation {
                        target: contentContainer
                        property: "yOffset"
                        from: interfaceWindow.height
                        to: 0
                        duration: Settings.animationSpeed.normal
                        easing.type: Settings.animationEasing.easeOut
                    }
                    PropertyAnimation {
                        target: contentContainer
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: Settings.animationSpeed.normal
                        easing.type: Settings.animationEasing.easeOut
                    }
                }

                SequentialAnimation {
                    id: closeAnimation
                    ParallelAnimation {
                        PropertyAnimation {
                            target: contentContainer
                            property: "yOffset"
                            to: interfaceWindow.height
                            duration: Settings.animationSpeed.normal
                            easing.type: Settings.animationEasing.easeOut
                        }
                        PropertyAnimation {
                            target: contentContainer
                            property: "opacity"
                            to: 0
                            duration: Settings.animationSpeed.normal
                            easing.type: Settings.animationEasing.easeOut
                        }
                    }
                    PropertyAction { target: interfaceLoader; property: "activeAsync"; value: false }
                }

                ColumnLayout {
                    id: contentLayout
                    
                    spacing: Settings.spacing.big

                    ColumnLayout {
                        id: descriptionColumn

                        Layout.fillWidth: true

                        spacing: Settings.spacing.medium

                        Text {
                            id: message

                            text: polkitAgent.flow?.message || message.text
                            font.pointSize: Settings.fontSize.smallTitle
                        }

                        Text {
                            id: supplementaryMessage

                            text: polkitAgent.flow?.supplementaryMessage || supplementaryMessage.text
                            visible: polkitAgent.flow?.supplementaryIsError ? false : polkitAgent.flow ? polkitAgent.flow?.supplementaryMessage !== "" : false

                            wrapMode: Text.WordWrap
                        }
                    }

                    Separator {
                        Layout.fillWidth: true
                    }

                    ColumnLayout {
                        id: inputColumn

                        Layout.fillWidth: true

                        spacing: Settings.spacing.medium

                        Text {
                            text: polkitAgent.flow ? polkitAgent.flow?.inputPrompt !== "" ? polkitAgent.flow?.inputPrompt : "Checking..." : ""
                            visible: text !== ""
                        }

                        Text {
                            text: polkitAgent.flow?.supplementaryIsError ? polkitAgent.flow?.supplementaryMessage : "Authentication failed, please try again"
                            color: Settings.palette.red
                            visible: polkitAgent.flow?.failed || false
                        }

                        TextField {
                            id: passwordInput

                            implicitWidth: contentContainer.width - contentContainer.border.width * 2 - contentContainer.leftMargin - contentContainer.rightMargin

                            echoMode: polkitAgent.flow?.responseVisible ? TextInput.Normal : TextInput.Password

                            onAccepted: submit()
                            onUnfocusRequested: cancel()
                        }
                    }

                    Separator {
                        Layout.fillWidth: true
                    }

                    Item {
                        implicitWidth: childrenRect.width
                        implicitHeight: childrenRect.height

                        RowLayout {
                            spacing: Settings.spacing.small

                            Button {
                                id: okButton

                                borderHoverColor: Settings.palette.green

                                topRightCornerRadius: Settings.radius.small
                                bottomRightCornerRadius: Settings.radius.small

                                enabled: passwordInput.text.length > 0 // || !!polkitAgent.flow?.isResponseRequired
                                
                                onClicked: submit()

                                Text {
                                    text: "Confirm"
                                }
                            }
                            Button {
                                borderHoverColor: Settings.palette.red

                                topLeftCornerRadius: Settings.radius.small
                                bottomLeftCornerRadius: Settings.radius.small

                                onClicked: cancel()

                                Text {
                                    text: "Cancel"
                                }
                            }
                        }
                    }
                }
            }

            MultiEffect {
                source: contentContainer
                anchors.fill: contentContainer
                shadowEnabled: true
                shadowBlur: 1.0
                blurMax: 16
                shadowColor: Qt.rgba(0, 0, 0, Config.theme.shadowOpacity)
            }

            Connections {
                target: polkitAgent.flow

                function onIsResponseRequiredChanged() {
                    passwordInput.text = ""
                    if (polkitAgent.flow.isResponseRequired) passwordInput.forceActiveFocus()
                }

                function onFailedChanged() {
                    if (polkitAgent.flow.failed) passwordInput.text = ""
                }
            }

            Connections {
                target: polkitAgent

                function onIsActiveChanged() {
                    if (!polkitAgent.isActive) interfaceWindow.cancel()
                }
            }
        }
    }

	PolkitAgent {
		id: polkitAgent

        onIsActiveChanged: () => {
            if (polkitAgent.isActive) interfaceLoader.activeAsync = true
        }
	}
}
