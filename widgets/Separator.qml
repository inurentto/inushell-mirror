import QtQuick

import qs.services
import qs.singletons



Item {
    property bool vertical: false
    property real margin: Settings.spacing.medium

    implicitWidth: Config.theme.borderWidth.normal
    implicitHeight: Config.theme.borderWidth.normal

    Rectangle {
        anchors.centerIn: parent

        implicitWidth: vertical ? Config.theme.borderWidth.normal : parent.width - parent.margin * 2
        implicitHeight: vertical ? parent.height - parent.margin * 2 : Config.theme.borderWidth.normal

        color: Settings.palette.background2

        radius: vertical ? implicitWidth : implicitHeight
    }
}