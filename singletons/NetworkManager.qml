pragma Singleton

import Quickshell
import Quickshell.Networking

Singleton {
    readonly property list<WiredDevice> connectedWiredDevices: Networking.devices.values.filter( device => device.type === DeviceType.Wired && device.connected )
    readonly property Network activeWiredNetwork: {
        if ( connectedWiredDevices.length > 0 ) {
            for ( var index = 0; index < connectedWiredDevices.length; index++ ) {
                return connectedWiredDevices[ index ].networks.values.find( network => network.connected )
            }
        }

        return null
    }

    readonly property list<WifiDevice> connectedWifiDevices: Networking.devices.values.filter( device => device.type === DeviceType.Wifi && device.connected )
    readonly property WifiNetwork activeWifiNetwork: {
        if ( connectedWifiDevices.length > 0 ) {
            for ( var index = 0; index < connectedWifiDevices.length; index++ ) {
                return connectedWifiDevices[ index ].networks.values.find( network => network.connected )
            }
        }

        return null
    }
}