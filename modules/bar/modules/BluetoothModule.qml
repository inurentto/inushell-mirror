import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.singletons
import qs.widgets
import qs.widgets.controls
import qs.widgets.bar
import qs.widgets.bar.bluetooth
import qs.resources



Module {
    id: root

    onClicked: () => {
        BluetoothManager.mainAdapter.enabled = !BluetoothManager.mainAdapter.enabled
    }

    areas: [
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.LeftButton

            panelContent: Component {
                ColumnLayout {
                    id: panel

                    property bool additionalActionsShown: false
                    readonly property bool busy: {
                        if (!bluetoothDeviceList.currentItem) return false
                        if (bluetoothDeviceList.currentItem.device.state === BluetoothDeviceState.Connected || bluetoothDeviceList.currentItem.device.state === BluetoothDeviceState.Disconnected) return false
                        else return true
                    }

                    function deviceSelected() {
                        trustButton.isToggled = bluetoothDeviceList.currentItem && bluetoothDeviceList.currentItem.device.trusted
                        blockButton.isToggled = bluetoothDeviceList.currentItem && bluetoothDeviceList.currentItem.device.blocked
                    }

                    spacing: Config.theme.spacing.normal

                    RowLayout {
                        id: actionRow

                        spacing: Config.theme.spacing.normal

                        Button {
                            id: connectionButton

                            enabled: bluetoothDeviceList.currentItem && !panel.busy

                            onClicked: () => {
                                if (bluetoothDeviceList.currentItem.device.connected) bluetoothDeviceList.currentItem.device.disconnect()
                                else bluetoothDeviceList.currentItem.device.connect()
                            }

                            Text {
                                text: {
                                    if (bluetoothDeviceList.currentItem === null) return "Connect"

                                    switch (bluetoothDeviceList.currentItem.device.state) {
                                        case BluetoothDeviceState.Disconnected: return "Connect"
                                        case BluetoothDeviceState.Connected: return "Disconnect"
                                        case BluetoothDeviceState.Disconnecting: return "Disconnecting..."
                                        case BluetoothDeviceState.Connecting: return "Connecting..."
                                    }
                                }

                                readonly property color _color: Config.theme.getForeground0()
                                color: {
                                    return Qt.rgba(
                                        _color.r * connectionButton.modulation.r,
                                        _color.g * connectionButton.modulation.g,
                                        _color.b * connectionButton.modulation.b,
                                        _color.a * connectionButton.modulation.a
                                    )
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Config.theme.animationSpeed.fast
                                        easing.type: Config.theme.easingType
                                    }
                                }
                            }
                        }

                        Button {
                            id: pairingButton

                            enabled: bluetoothDeviceList.currentItem && !panel.busy

                            onClicked: () => {
                                if (bluetoothDeviceList.currentItem.device.pairing) bluetoothDeviceList.currentItem.device.cancelPair()
                                else if (bluetoothDeviceList.currentItem.device.paired) bluetoothDeviceList.currentItem.device.forget()
                                else bluetoothDeviceList.currentItem.device.pair()
                            }

                            Text {
                                text: {
                                    if (bluetoothDeviceList.currentItem === null) return "Pair"
                                    else if (bluetoothDeviceList.currentItem.device.pairing) return "Pairing..."
                                    else if (bluetoothDeviceList.currentItem.device.paired) return "Forget"
                                    else return "Pair"
                                }

                                readonly property color _color: Config.theme.getForeground0()
                                color: {
                                    return Qt.rgba(
                                        _color.r * pairingButton.modulation.r,
                                        _color.g * pairingButton.modulation.g,
                                        _color.b * pairingButton.modulation.b,
                                        _color.a * pairingButton.modulation.a
                                    )
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Config.theme.animationSpeed.fast
                                        easing.type: Config.theme.easingType
                                    }
                                }
                            }
                        }

                        Button {
                            id: trustButton

                            enabled: bluetoothDeviceList.currentItem && !panel.busy
                            visible: panel.additionalActionsShown

                            toggleable: true

                            backgroundPressColor: Config.theme.getGreen()

                            onToggled: () => {
                                bluetoothDeviceList.currentItem.device.trusted = isToggled
                            }

                            Text {
                                text: bluetoothDeviceList.currentItem && bluetoothDeviceList.currentItem.device.trusted ? "Trusted" : "Trust"
                                readonly property color _color: bluetoothDeviceList.currentItem && bluetoothDeviceList.currentItem.device.trusted ? Config.theme.getBackground0() : Config.theme.getForeground0()
                                color: {
                                    return Qt.rgba(
                                        _color.r * trustButton.modulation.r,
                                        _color.g * trustButton.modulation.g,
                                        _color.b * trustButton.modulation.b,
                                        _color.a * trustButton.modulation.a
                                    )
                                }
                                
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Config.theme.animationSpeed.fast
                                        easing.type: Config.theme.easingType
                                    }
                                }
                            }
                        }

                        Button {
                            id: blockButton

                            enabled: bluetoothDeviceList.currentItem && !panel.busy
                            visible: panel.additionalActionsShown

                            toggleable: true

                            backgroundPressColor: Config.theme.getRed()

                            onToggled: () => {
                                bluetoothDeviceList.currentItem.device.blocked = isToggled
                            }

                            Text {
                                text: bluetoothDeviceList.currentItem && bluetoothDeviceList.currentItem.device.blocked ? "Unblock" : "Block"
                                readonly property color _color: bluetoothDeviceList.currentItem && bluetoothDeviceList.currentItem.device.blocked ? Config.theme.getBackground0() : Config.theme.getForeground0()
                                color: {
                                    return Qt.rgba(
                                        _color.r * blockButton.modulation.r,
                                        _color.g * blockButton.modulation.g,
                                        _color.b * blockButton.modulation.b,
                                        _color.a * blockButton.modulation.a
                                    )
                                }
                                
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Config.theme.animationSpeed.fast
                                        easing.type: Config.theme.easingType
                                    }
                                }
                            }
                        }

                        Button {
                            id: drawerButton

                            implicitWidth: height

                            onClicked: () => {
                                panel.additionalActionsShown = !panel.additionalActionsShown
                                deviceSelected()
                            }

                            Text {
                                text: panel.additionalActionsShown ? "<" : ">"
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Button {
                            id: discoverButton

                            visible: !panel.additionalActionsShown
                            toggleable: true

                            backgroundPressColor: Config.theme.getAccent()

                            onToggled: () => {
                                Bluetooth.defaultAdapter.discovering = isToggled
                            }

                            Text {
                                text: Bluetooth.defaultAdapter.discovering ? "Stop Discovering" : "Discover"
                                readonly property color _color: Bluetooth.defaultAdapter.discovering ? Config.theme.getBackground0() : Config.theme.getForeground0()
                                color: {
                                    return Qt.rgba(
                                        _color.r * discoverButton.modulation.r,
                                        _color.g * discoverButton.modulation.g,
                                        _color.b * discoverButton.modulation.b,
                                        _color.a * discoverButton.modulation.a
                                    )
                                }
                                
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Config.theme.animationSpeed.fast
                                        easing.type: Config.theme.easingType
                                    }
                                }
                            }
                        }
                    }

                    Separator {
                        Layout.fillWidth: true
                    }

                    StyledListView {
                        id: bluetoothDeviceList

                        implicitWidth: 500
                        implicitHeight: Math.min(contentHeight, 450)

                        model: BluetoothManager.devices
                        delegate: Device {
                            required property int index
                            required property BluetoothDevice modelData
                            device: modelData
                            selected: this === bluetoothDeviceList.currentItem

                            implicitWidth: bluetoothDeviceList.width

                            onClicked: () => {
                                if (!panel.busy) {
                                    if (bluetoothDeviceList.currentIndex === index) bluetoothDeviceList.currentIndex = -1
                                    else bluetoothDeviceList.currentIndex = index
                                }

                                for (let buttonIndex = 0; buttonIndex < bluetoothDeviceList.count; buttonIndex++) {
                                    const device = bluetoothDeviceList.itemAtIndex(buttonIndex)
                                    device.isToggled = bluetoothDeviceList.currentItem === device
                                }

                                panel.deviceSelected()
                            }
                        }
                        reuseItems: true

                        ScrollBar.vertical: ScrollBar {}
                    }
                }
            }

            RowLayout {
                TintedIcon {
                    source: BluetoothManager.mainAdapter?.enabled ? Icons.getIcon("network-bluetooth-activated") : Icons.getIcon("network-bluetooth")
                }

                Text {
                    text: BluetoothManager.mainAdapter?.enabled ? BluetoothManager.connectedDevices.length : "Disabled"
                    verticalAlignment: Text.AlignVCenter
                    color: PanelManager.currentOpenPanel === "performance" ? Config.theme.getAccent() : Config.theme.getForeground0()
                }
            }
        }
    ]
}