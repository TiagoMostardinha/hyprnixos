pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// The session's notification daemon: apps' notifications land here, and the island shows the newest.
Singleton {
    id: root

    property Notification latest: null
    readonly property var all: server.trackedNotifications.values
    // Newest first, for lists.
    readonly property var history: all.slice().reverse()

    // Picture sent with the notification first, then the app's icon (full colour); "" if neither.
    function icon(notification) {
        if (!notification)
            return "";
        if (notification.image)
            return notification.image;
        const name = notification.appIcon || DesktopEntries.heuristicLookup(notification.desktopEntry || notification.appName)?.icon || "";
        return name.startsWith("/") || name.includes("://") ? name : Quickshell.iconPath(name, true);
    }

    function clear() {
        all.slice().forEach(notification => notification.dismiss());
    }

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
