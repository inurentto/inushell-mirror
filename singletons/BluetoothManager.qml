pragma Singleton

import Quickshell
import Quickshell.Bluetooth



Singleton {
    id: root

    readonly property list<BluetoothDevice> devices: Bluetooth.devices.values
    readonly property list<BluetoothDevice> connectedDevices: devices.filter(device => device.connected)
    readonly property list<BluetoothDevice> disconnectedDevices: devices.filter(device => !device.connected)

    readonly property BluetoothAdapter mainAdapter: Bluetooth.defaultAdapter
}