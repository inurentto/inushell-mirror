import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.bar
import qs.resources




Module {
    id: root

    property int profileScrollY

    onWheel: (wheel, area) => {
        if (area.name === "power-profile") {
            if (PowerProfiles.hasPerformanceProfile) {
                root.profileScrollY += wheel.angleDelta.y
                
                if (Math.abs(root.profileScrollY) >= 15 * 10) {
                    PowerManager.incrementPowerProfile(Math.sign(root.profileScrollY))
                    root.profileScrollY = 0
                }

                if (MediaManager.activePlayer?.volume > 1) MediaManager.activePlayer.volume = 1
                else if (MediaManager.activePlayer?.volume < 0) MediaManager.activePlayer.volume = 0
            }
        }
    }

    areas: [
        ModuleArea {
            window: root.window

            name: "batteries"

            // User should be able to select what battery is shown on the module, defaults to laptop battery if it exists (though still changeable).

            RowLayout {
                TintedIcon {
                    source: PowerManager.mainBattery ? Icons.getBatteryIcon(PowerManager.mainBattery.percentage, PowerManager.isCharging(PowerManager.mainBattery)) : Icons.getIcon("battery-missing-symbolic")
                }

                Text {
                    text: PowerManager.mainBattery ? Math.floor(PowerManager.mainBattery.percentage * 100) + "%" : PowerManager.batteries.length
                    verticalAlignment: Text.AlignVCenter
                    color: PanelManager.currentOpenPanel === "battery" ? Settings.palette.accent : Settings.palette.foreground0
                }
            }

            enabled: PowerManager.batteries.length > 0
        },

        ModuleArea {
            window: root.window
            id: powerProfileArea
            name: "power-profile"

            readonly property color profileColor: {
                switch (PowerProfiles.profile) {
                    case PowerProfile.Performance: return Settings.palette.red
                    case PowerProfile.Balanced: return Settings.palette.foreground0
                    case PowerProfile.PowerSaver: return Settings.palette.green
                }
            }

            RowLayout {
                TintedIcon {
                    source: Icons.getPowerProfileIcon(PowerProfiles.profile)
                    tint: powerProfileArea.profileColor
                }

                Text {
                    text: PowerManager.getPowerProfileName(PowerProfiles.profile)
                    verticalAlignment: Text.AlignVCenter
                }
            }

            enabled: PowerProfiles.hasPerformanceProfile
        }
    ]
}