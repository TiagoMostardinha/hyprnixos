pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

// The session's notification daemon: apps' notifications land here, and the island shows the newest.
Singleton {
    id: root

    property Notification latest: null
    // Do not disturb: notifications are still received and listed, but don't pop up on the island.
    property bool dnd: false
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

    // Brings up the app that sent a notification: its open window if there is one, otherwise launches it.
    function openApp(notification) {
        const entry = DesktopEntries.heuristicLookup(notification.desktopEntry || notification.appName);
        const names = [entry?.id, entry?.startupClass, notification.desktopEntry, notification.appName].filter(name => name).map(name => name.toLowerCase());
        const window = ToplevelManager.toplevels.values.find(toplevel => names.includes(toplevel.appId.toLowerCase()));
        if (window)
            window.activate();
        else
            entry?.execute();
    }

    function clear() {
        all.slice().forEach(notification => notification.dismiss());
    }

    // When each notification arrived (by id), for the "5m"-style time in lists; the server doesn't keep it.
    property var received: ({})

    // Time since a notification arrived: "now", "5m", "2h", "3d". Follows the clock, so it updates every minute.
    function ago(notification) {
        const at = received[notification?.id];
        if (!at)
            return "";
        const minutes = Math.floor((Time.date - at) / 60000);
        if (minutes < 1)
            return "now";
        if (minutes < 60)
            return minutes + "m";
        if (minutes < 60 * 24)
            return Math.floor(minutes / 60) + "h";
        return Math.floor(minutes / (60 * 24)) + "d";
    }

    signal arrived(Notification notification)

    NotificationServer {
        id: server

        keepOnReload: false
        bodySupported: true
        bodyMarkupSupported: false
        imageSupported: true
        // No action buttons: apps that need them (like Blueman's pairing request) fall back to their own
        // dialog instead of a notification the island can't answer.
        actionsSupported: false

        onNotification: notification => {
            notification.tracked = true;
            root.received[notification.id] = new Date();
            root.latest = notification;
            root.arrived(notification);
        }
    }
}
