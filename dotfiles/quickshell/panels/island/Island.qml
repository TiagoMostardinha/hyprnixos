import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Wayland
import "../../services"

PanelWindow {
    id: root

    property string card: "Idle"
    // The media card replaces the left orb next to whatever card is in the middle.
    property bool media: false
    // Brightness, Volume or Notification, shown briefly over the middle card.
    property string osd: ""
    property bool armed: false

    readonly property int orbSize: 28
    readonly property int top: 8
    readonly property int shadowRoom: 16

    readonly property Item center: osd ? osdLoader.item : cardLoader.item
    readonly property bool solo: cardLoader.item?.side === "solo"
    // Cards you type into or steer with keys: they take the keyboard, and overlays never cover them.
    readonly property bool typing: ["Launcher", "Polkit", "Workspaces"].includes(card)
    readonly property Item left: media ? mediaLoader.item : leftOrb
    // The control center and its menus: new notifications wait in its notification box instead of popping up.
    readonly property bool controlCenter: ["ControlCenter", "WifiMenu", "BluetoothMenu"].includes(card)

    // The orbs sit just outside the centered card, so they spread as it grows.
    readonly property real orbOffset: center ? center.width / 2 + center.gap : 0

    screen: Quickshell.screens.find(s => s.name === "eDP-1") ?? null
    anchors.top: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "island"
    WlrLayershell.keyboardFocus: typing ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand

    implicitHeight: top + scene.height + shadowRoom
    color: "transparent"

    // Big standalone cards (control center, gateway) close the media card; the orbs stay.
    onSoloChanged: if (solo)
        media = false

    // Shows an overlay card for `duration` ms (0 keeps it until dismissed). Skipped while a solo or
    // keyboard-driven card is open, so it never covers a prompt you are typing into.
    function flash(name, duration) {
        if (!armed || solo || typing)
            return;
        osd = name;
        osdTimer.interval = duration;
        if (duration > 0)
            osdTimer.restart();
        else
            osdTimer.stop();
    }

    // Super + Space runs `qs ipc call island launcher`, Super + Tab `qs ipc call island workspaces`,
    // Super + M `qs ipc call island gateway`.
    IpcHandler {
        target: "island"

        function launcher(): void {
            root.card = root.card === "Launcher" ? "Idle" : "Launcher";
        }

        function workspaces(): void {
            root.card = root.card === "Workspaces" ? "Idle" : "Workspaces";
        }

        function gateway(): void {
            root.card = root.card === "Gateway" ? "Idle" : "Gateway";
        }
    }

    Timer {
        id: osdTimer
        // Stay up while the pointer is on the OSD.
        onTriggered: osdLoader.item?.active ? restart() : root.osd = ""
    }

    // Levels settle as the services connect at startup; only react to changes after that.
    Timer {
        running: true
        interval: 1000
        onTriggered: root.armed = true
    }

    // The gateway card takes the keyboard (for Escape) and closes when you click anywhere else.
    HyprlandFocusGrab {
        windows: [root]
        active: root.card === "Gateway"
        onCleared: root.card = "Idle"
    }

    // A polkit request opens its prompt; it closes once the request ends.
    Connections {
        target: Polkit

        function onActiveChanged() {
            root.card = Polkit.active ? "Polkit" : "Idle";
        }
    }

    Connections {
        target: Brightness

        function onLevelChanged() {
            root.flash("Brightness", 1500);
        }
    }

    Connections {
        target: Audio

        function onVolumeChanged() {
            root.flash("Volume", 1500);
        }

        function onMutedChanged() {
            root.flash("Volume", 1500);
        }
    }

    // A new notification shows for the time the app asked (5s by default); critical ones stay until clicked.
    Connections {
        target: Notifications

        function onArrived(notification) {
            const critical = notification.urgency === NotificationUrgency.Critical;
            // Do not disturb holds back everything but critical notifications.
            if (Notifications.dnd && !critical)
                return;
            const timeout = notification.expireTimeout > 0 ? notification.expireTimeout : 5000;
            if (!root.controlCenter)
                root.flash("Notification", critical ? 0 : timeout);
        }
    }

    // Hide the notification once it's gone: the app closed it, it expired, or it was clicked.
    Connections {
        target: Notifications.latest

        function onClosed() {
            if (root.osd === "Notification")
                root.osd = "";
        }
    }

    mask: Region {
        Region { item: root.left }
        Region { item: root.center }
        Region { item: rightOrb }
    }

    Item {
        id: scene

        y: root.top
        width: root.width
        height: Math.max(root.orbSize, root.center ? root.center.drop + root.center.height : 0, root.media && root.left ? root.left.drop + root.left.height : 0)

        focus: true
        Keys.onEscapePressed: {
            if (Polkit.active)
                Polkit.flow.cancelAuthenticationRequest();
            root.card = "Idle";
            root.media = false;
        }
        // With the media card open (and no keyboard-driven card in the middle), Space pauses or resumes
        // and Alt + ← / → goes to the previous / next song.
        Keys.onPressed: event => {
            if (!root.media || root.typing)
                return;
            const alt = event.modifiers & Qt.AltModifier;
            if (event.key === Qt.Key_Space && !alt)
                Media.player?.togglePlaying();
            else if (event.key === Qt.Key_Left && alt && Media.player?.canGoPrevious)
                Media.player.previous();
            else if (event.key === Qt.Key_Right && alt && Media.player?.canGoNext)
                Media.player.next();
            else
                return;
            event.accepted = true;
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "black"
            shadowOpacity: IslandTheme.shadowOpacity
            shadowBlur: IslandTheme.shadowBlur
            shadowVerticalOffset: IslandTheme.shadowOffset
        }

        Loader {
            id: cardLoader

            visible: !root.osd
            x: scene.width / 2 - (item?.width ?? 0) / 2
            y: item ? item.drop : 0
            source: root.card + "Card.qml"

            MouseArea {
                anchors.fill: parent
                enabled: root.card === "Idle"
                onClicked: root.card = "Week"
            }

            Connections {
                target: cardLoader.item
                ignoreUnknownSignals: true

                function onOpen(card) {
                    root.card = card;
                }
            }
        }

        Loader {
            id: osdLoader

            active: root.osd !== ""
            x: scene.width / 2 - (item?.width ?? 0) / 2
            y: item ? item.drop : 0
            source: root.osd ? root.osd + "Card.qml" : ""
        }

        Loader {
            id: mediaLoader

            active: root.media
            x: scene.width / 2 - (root.center?.width ?? 0) / 2 - (item?.gap ?? 0) - (item?.width ?? 0)
            y: item ? item.drop : 0
            source: "MediaCard.qml"
        }

        CoverOrb {
            id: leftOrb

            visible: !root.media
            x: scene.width / 2 - root.orbOffset - width

            MouseArea {
                anchors.fill: parent
                onClicked: root.media = true
            }
        }

        StatusOrb {
            id: rightOrb

            x: scene.width / 2 + root.orbOffset
            battery: Battery.available ? Battery.percent / 100 : 1
            networkIcon: Network.icon

            MouseArea {
                anchors.fill: parent
                // Toggles the control center (also from its Wi-Fi or Bluetooth menu).
                onClicked: root.card = root.controlCenter ? "Idle" : "ControlCenter"
            }
        }
    }
}
