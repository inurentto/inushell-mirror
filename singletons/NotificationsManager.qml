pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

import qs.resources



Singleton {
    id: root

    readonly property int defaultNotificationDuration: 8000

    property list<NotificationWrapper> list: []
    readonly property list<NotificationWrapper> open: list.filter(notification => !notification?.closed)
    readonly property list<NotificationWrapper> openNonTransient: open.filter(notification => !notification?.transient)
    readonly property list<NotificationWrapper> popups: open.filter(notification => notification?.popup)
    property alias doNotDisturb: persistantProperties.doNotDisturb

    NotificationServer {
        id: server

        keepOnReload: true

        bodySupported: true
        bodyMarkupSupported: false
        bodyHyperlinksSupported: false
        bodyImagesSupported: true
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: true
        inlineReplySupported: false
        persistenceSupported: true

        onNotification: (notification) => {
            notification.tracked = true;

            const component = notificationHolder.createObject(root, {
                popup: !doNotDisturb,
                rawNotification: notification
            })
            root.list = [component, ...root.list];
        }
    }

    PersistentProperties {
        id: persistantProperties

        property bool doNotDisturb
    }

    Component {
        id: notificationHolder

        NotificationWrapper {}
    }
}