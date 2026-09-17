import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.controls



Button {
    id: root

    required property BluetoothDevice device
    property bool selected: false

    backgroundColor: selected ? Settings.palette.accent : Settings.palette.background1
    backgroundHoverColor: selected ? Settings.palette.accent : Settings.palette.background2
    backgroundPressColor: selected ? Settings.palette.accent : Settings.palette.background0

    RowLayout {
        spacing: Settings.spacing.medium

        TintedIcon {
            property string deviceIcon: Icons.getIcon(device.icon)

            source: {
                const deviceIcon = Icons.getIcon(device.icon)
                const fallbackIcon = Icons.getIcon("bluetooth")

                if (deviceIcon === "") return fallbackIcon
                else return deviceIcon
            }
            tint: root.selected ? Settings.palette.background0 : Settings.palette.foreground0

            Behavior on tint {
                ColorAnimation {
                    duration: Settings.animationSpeed.fast
                    easing.type: Settings.animationEasing.easeOut
                }
            }
        }

        Text {
            text: device.name
            color: root.selected ? Settings.palette.background0 : Settings.palette.foreground0
            elide: Text.ElideRight

            Behavior on color {
                ColorAnimation {
                    duration: Settings.animationSpeed.fast
                    easing.type: Settings.animationEasing.easeOut
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: "Connected"
            color: root.selected ? Settings.palette.background0 : Settings.palette.foreground2
            visible: device.connected

            Behavior on color {
                ColorAnimation {
                    duration: Settings.animationSpeed.fast
                    easing.type: Settings.animationEasing.easeOut
                }
            }
        }
    }
}