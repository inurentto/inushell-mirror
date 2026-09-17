import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.singletons
import qs.widgets
import qs.widgets.bar
import qs.resources




Module {
    id: root

    areas: [
        ModuleArea {
            window: root.window
            acceptedButtons: Qt.NoButton

            enabled: NetworkManager.activeWiredNetwork !== null

            aspectRatio: 1

            panelContent: Component {
                ColumnLayout {
                    spacing: Settings.spacing.medium

                    Text {
                        Layout.fillWidth: true

                        text: NetworkManager.activeWiredNetwork.name
                        font.pointSize: Settings.fontSize.smallTitle
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        Layout.fillWidth: true

                        text: `Speed: ${NetworkManager.activeWiredNetwork.device.linkSpeed.toString()} Mbps`
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            TintedIcon {
                source: Icons.getNetworkWiredIcon(NetworkManager.activeWiredNetwork)
            }
        },

        ModuleArea {
            window: root.window
            acceptedButtons: Qt.NoButton

            enabled: NetworkManager.activeWifiNetwork !== null

            aspectRatio: 1

            panelContent: Component {
                ColumnLayout {
                    spacing: Settings.spacing.medium

                    Text {
                        Layout.fillWidth: true

                        text: NetworkManager.activeWifiNetwork.name
                        font.pointSize: Settings.fontSize.smallTitle
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        Layout.fillWidth: true

                        text: `Signal Strength: ${Math.floor(NetworkManager.activeWifiNetwork.signalStrength * 100)}%`
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        Layout.fillWidth: true

                        text: {
                            `Security: ${WifiSecurityType.toString(NetworkManager.activeWifiNetwork.security)}`
                        }
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }

            TintedIcon {
                source: Icons.getNetworkWifiIcon(NetworkManager.activeWifiNetwork)
            }
        }
    ]
}