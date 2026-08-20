pragma Singleton

import Quickshell
import Quickshell.Networking
import Quickshell.Bluetooth
import Quickshell.Services.Notifications
import Quickshell.Services.UPower



Singleton {
    id: root

    readonly property var uPowerDeviceIcons: ({
        "Pen": "",
        "Media Player": "",
        "Pda": "",
        "Keyboard": "",
        "Touchpad": "",
        "Printer": "",
        "Ups": "",
        "Tablet": "",
        "Modem": "",
        "Bluetooth Generic": "",
        "Other Audio": "",
        "Headphones": "",
        "Gaming Input": "",
        "Phone": "",
        "Wearable": "",
        "Network": "",
        "Video": "",
        "Mouse": "",
        "Computer": "",
        "Camera": "",
        "Remote Control": "",
        "Line Power": "",
        "Headset": "",
        "Unknown": "",
        "Battery": "",
        "Scanner": "",
        "Speakers": "",
        "Toy": "",
        "Monitor": ""
    })

    function getIcon( id: string ): string {
        return Quickshell.iconPath( id, true )
    }

    function getNetworkWifiIcon( wifiNetwork: WifiNetwork ): string {
        if ( wifiNetwork === null || !wifiNetwork.connected ) return getIcon( "network-wireless-disconnected-symbolic" )

        if ( wifiNetwork.signalStrength >= 100 / 100 ) return getIcon( "network-wireless-connected-100-symbolic" )
        if ( wifiNetwork.signalStrength >= 80 / 100 ) return getIcon( "network-wireless-connected-80-symbolic" )
        if ( wifiNetwork.signalStrength >= 75 / 100 ) return getIcon( "network-wireless-connected-75-symbolic" )
        if ( wifiNetwork.signalStrength >= 60 / 100 ) return getIcon( "network-wireless-connected-60-symbolic" )
        if ( wifiNetwork.signalStrength >= 50 / 100 ) return getIcon( "network-wireless-connected-50-symbolic" )
        if ( wifiNetwork.signalStrength >= 40 / 100 ) return getIcon( "network-wireless-connected-40-symbolic" )
        if ( wifiNetwork.signalStrength >= 25 / 100 ) return getIcon( "network-wireless-connected-25-symbolic" )
        if ( wifiNetwork.signalStrength >= 20 / 100 ) return getIcon( "network-wireless-connected-20-symbolic" )
        return getIcon( "network-wireless-connected-00-symbolic" )
    }

    function getNetworkWiredIcon( wiredNetwork: Network ): string {
        if ( wiredNetwork === null || !wiredNetwork.connected ) return getIcon( "network-wired-disconnected-symbolic" )

        return getIcon( "network-wired-activated-symbolc" )
    }

    function getSinkVolumeIcon( volume: real, isMuted: bool ): string {
        if ( isMuted ) return getIcon( "audio-volume-muted-symbolic" )

        if ( volume >= 0.5 ) return getIcon( "audio-volume-high-symbolic" )
        if ( volume > 0 ) return getIcon( "audio-volume-medium-symbolic" )
        return getIcon( "audio-volume-low-symbolic" )
    }

    function getSourceVolumeIcon( volume: real, isMuted: bool ): string {
        if ( isMuted ) return getIcon( "audio-input-microphone-muted-symbolic" )

        if ( volume >= 0.5 ) return getIcon( "audio-input-microphone-high-symbolic" )
        if ( volume > 0 ) return getIcon( "audio-input-microphone-medium-symbolic" )
        return getIcon( "audio-input-microphone-low-symbolic" )
    }

    function getBatteryIcon( percentage: real, charging: bool ): string {
        if ( charging ) {
            if ( percentage >= 1 ) return getIcon( "battery-100-charging-symbolic" )
            if ( percentage >= 0.9 ) return getIcon( "battery-90-charging-symbolic" )
            if ( percentage >= 0.8 ) return getIcon( "battery-80-charging-symbolic" )
            if ( percentage >= 0.7 ) return getIcon( "battery-70-charging-symbolic" )
            if ( percentage >= 0.6 ) return getIcon( "battery-60-charging-symbolic" )
            if ( percentage >= 0.5 ) return getIcon( "battery-50-charging-symbolic" )
            if ( percentage >= 0.4 ) return getIcon( "battery-40-charging-symbolic" )
            if ( percentage >= 0.3 ) return getIcon( "battery-30-charging-symbolic" )
            if ( percentage >= 0.2 ) return getIcon( "battery-20-charging-symbolic" )
            if ( percentage >= 0.1 ) return getIcon( "battery-10-charging-symbolic" )
            
            return getIcon( "battery-0-charging-symbolic" )
        } else {
            if ( percentage >= 1 ) return getIcon( "battery-100-symbolic" )
            if ( percentage >= 0.9 ) return getIcon( "battery-90-symbolic" )
            if ( percentage >= 0.8 ) return getIcon( "battery-80-symbolic" )
            if ( percentage >= 0.7 ) return getIcon( "battery-70-symbolic" )
            if ( percentage >= 0.6 ) return getIcon( "battery-60-symbolic" )
            if ( percentage >= 0.5 ) return getIcon( "battery-50-symbolic" )
            if ( percentage >= 0.4 ) return getIcon( "battery-40-symbolic" )
            if ( percentage >= 0.3 ) return getIcon( "battery-30-symbolic" )
            if ( percentage >= 0.2 ) return getIcon( "battery-20-symbolic" )
            if ( percentage >= 0.1 ) return getIcon( "battery-10-symbolic" )
            
            return getIcon( "battery-0-symbolic" )
        }

        return getIcon( "battery-missing" )
    }

    function getPowerProfileIcon( powerProfile: int ): string {
        switch ( powerProfile ) {
            case PowerProfile.Performance: return getIcon( "battery-profile-performance-symbolic" )
            case PowerProfile.Balanced: return getIcon( "battery-profile-balanced-symbolic" )
            case PowerProfile.PowerSaver: return getIcon( "battery-profile-powersave-symbolic" )
        }
    }

    function getUPowerDeviceIcon( type: int ): string {
        return uPowerDeviceIcons[ UPowerDeviceType.toString( type ) ]
    }

    function getBluetoothDeviceStateIcon( deviceState: int ): string {
        switch ( deviceState ) {
            case BluetoothDeviceState.Connected: return "check"
            case BluetoothDeviceState.Connecting: return "indeterminate"
            case BluetoothDeviceState.Disconnected: return "cross"
            case BluetoothDeviceState.Disconnecting: return "indeterminate"
            default: return "question-mark"
        }
    }

    function getAppIcon( name: string, fallback: string ): string {
        if ( name !== "undefined" && name !== "" ) {
            const themeIcon = Quickshell.iconPath( name.toLowerCase( ), true )
            if ( themeIcon !== "" ) return themeIcon

            const desktopEntryIconName = DesktopEntries.heuristicLookup( name.toLowerCase( ) )?.icon
            const desktopEntryIcon = Quickshell.iconPath( desktopEntryIconName, true)
            if ( desktopEntryIcon ) return desktopEntryIcon
        }

        if ( fallback !== "undefined" && fallback !== "" ) return getAppIcon( fallback )
        return ""
    }

    function getTrayIcon( id: string, icon: string ): string {
        //const themeIcon = Quickshell.iconPath( id, true )
        //if ( themeIcon !== "" ) return themeIcon

        if ( icon.includes( "?path=" ) ) {
            const [ name, path ] = icon.split( "?path=");
            icon = Qt.resolvedUrl( `${ path }/${ name.slice( name.lastIndexOf( "/" ) + 1 ) }` );
        }
        return icon;
    }
}