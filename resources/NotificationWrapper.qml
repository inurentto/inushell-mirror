import Quickshell.Services.Notifications
import QtQuick

import qs.services
import qs.singletons



QtObject {
    id: root

    required property Notification rawNotification
    property bool popup: true
    property bool closed: false

    property int id: -1
    property string summary: ""
    property string body: ""
    property string appIcon: ""
    property string appName: ""
    property string image: ""
    property real startTimestamp: Date.now()
    property real expireTimeout: NotificationsManager.defaultNotificationDuration
    property int urgency: NotificationUrgency.Normal
    property bool resident: false
    property bool hasActionIcons: false
    property NotificationAction mainAction: null
    property list<NotificationAction> actions: []

    readonly property Timer timer: Timer {
        running: true
        interval: root.expireTimeout
        onTriggered: {
            root.popup = false;
        }
    }

    readonly property Connections connections: Connections {
        target: root.rawNotification

        function onClosed(): void {
            root.close()
        }

        function onSummaryChanged(): void {
            root.summary = root.rawNotification.summary
            root.replayPopup()
        }

        function onBodyChanged(): void {
            root.body = root.rawNotification.body
            root.replayPopup()
        }

        function onAppIconChanged(): void {
            root.appIcon = root.rawNotification.appIcon
        }

        function onAppNameChanged(): void {
            root.appName = root.rawNotification.appName
        }

        function onImageChanged(): void {
            root.image = root.rawNotification.image
            root.replayPopup()
        }

        function onExpireTimeoutChanged(): void {
            root.expireTimeout = root.rawNotification.expireTimeout
        }

        function onUrgencyChanged(): void {
            root.urgency = root.rawNotification.urgency
        }

        function onResidentChanged(): void {
            root.resident = root.rawNotification.resident
        }

        function onHasActionIconsChanged(): void {
            root.hasActionIcons = root.rawNotification.hasActionIcons
        }

        function onActionsChanged(): void {
            registerActions()
        }
    }

    function close(): void {
        root.closed = true
    }

    function dismiss(): void {
        root.close()
        root.popup = false
        root.rawNotification.dismiss()
    }

    function replayPopup(): void {
        root.popup = true
        root.startTimestamp = Date.now()
        root.timer.restart()
    }

    function registerActions(): void {
        root.actions = root.rawNotification.actions.filter(action => action.identifier !== "default")
        root.mainAction = root.rawNotification.actions.find(action => action.identifier === "default")
    }

    Component.onCompleted: {
        if (!rawNotification) return

        id = rawNotification.id
        summary = rawNotification.summary
        body = rawNotification.body
        appIcon = rawNotification.appIcon
        appName = rawNotification.appName
        image = rawNotification.image
        expireTimeout = rawNotification.expireTimeout > 0 ? rawNotification.expireTimeout : NotificationsManager.defaultNotificationDuration
        urgency = rawNotification.urgency
        resident = rawNotification.resident
        hasActionIcons = rawNotification.hasActionIcons

        registerActions()
    }
}