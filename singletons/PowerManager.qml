pragma Singleton

import Quickshell
import Quickshell.Services.UPower



Singleton {
    id: root

    readonly property list<UPowerDevice> batteries: UPower.devices.values
    readonly property UPowerDevice mainBattery: UPower.displayDevice && UPower.displayDevice.ready && UPower.displayDevice.isLaptopBattery ? UPower.displayDevice : null
    readonly property list<UPowerDevice> externalBatteries: batteries.filter(device => !device.isLaptopBattery)

    readonly property list<int> powerProfileOrder: [
        2,
        1,
        0
    ]

    function getPowerProfileName(powerProfile: int): string {
        switch (powerProfile) {
            case PowerProfile.Performance: return "Performance"
            case PowerProfile.Balanced: return "Balanced"
            case PowerProfile.PowerSaver: return "Power Saving"
        }
    }

    function incrementPowerProfile(increment: int): void {
        let position = root.powerProfileOrder.indexOf(PowerProfiles.profile)
        let nextPosition = (((position + increment) % root.powerProfileOrder.length) + root.powerProfileOrder.length) % root.powerProfileOrder.length;

        setPowerProfile(powerProfileOrder[ nextPosition ])
    }

    function setPowerProfile(powerProfile: int): void {
        PowerProfiles.profile = powerProfile
    }

    function isCharging(battery: UPowerDevice): bool {
        return battery.state === UPowerDeviceState.PendingCharge || battery.state === UPowerDeviceState.Charging
    }
}