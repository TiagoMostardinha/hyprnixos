pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// The session's notification daemon: apps' notifications land here, and the island shows the newest.
Singleton {
    id: root

    property Notification latest: null
    readonly property var all: server.trackedNotifications.values

    signal arrived(Notification notification)

    NotificationServer {
        id: server

        keepOnReload: false
        bodySupported: true
        bodyMarkupSupported: false
        imageSupported: true
        actionsSupported: true

        onNotification: notification => {
            notification.tracked = true;
            root.latest = notification;
            root.arrived(notification);
        }
    }
}
