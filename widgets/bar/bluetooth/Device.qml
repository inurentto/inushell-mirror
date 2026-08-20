import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

import qs.singletons
import qs.widgets
import qs.widgets.controls



Button {
    id: root

    required property BluetoothDevice device
    property bool selected: false

    backgroundColor: selected ? Config.theme.getAccent() : Config.theme.getBackground1()
    backgroundHoverColor: selected ? Config.theme.getAccent() : Config.theme.getBackground2()
    backgroundPressColor: selected ? Config.theme.getAccent() : Config.theme.getBackground0()

    RowLayout {
        spacing: Config.theme.spacing.normal

        TintedIcon {
            property string deviceIcon: Icons.getIcon(device.icon)

            source: {
                const deviceIcon = Icons.getIcon(device.icon)
                const fallbackIcon = Icons.getIcon("bluetooth")

                if (deviceIcon === "") return fallbackIcon
                else return deviceIcon
            }
            tint: root.selected ? Config.theme.getBackground0() : Config.theme.getForeground0()

            Behavior on tint {
                ColorAnimation {
                    duration: Config.theme.animationSpeed.fast
                    easing.type: Config.theme.easingType
                }
            }
        }

        Text {
            text: device.name
            color: root.selected ? Config.theme.getBackground0() : Config.theme.getForeground0()
            elide: Text.ElideRight

            Behavior on color {
                ColorAnimation {
                    duration: Config.theme.animationSpeed.fast
                    easing.type: Config.theme.easingType
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Text {
            text: "Connected"
            color: root.selected ? Config.theme.getBackground0() : Config.theme.getForeground2()
            visible: device.connected

            Behavior on color {
                ColorAnimation {
                    duration: Config.theme.animationSpeed.fast
                    easing.type: Config.theme.easingType
                }
            }
        }
    }
}