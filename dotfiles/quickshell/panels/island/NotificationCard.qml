import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "../../services"

IslandCard {
    id: card

    readonly property Notification notification: Notifications.latest
    readonly property bool active: area.containsMouse
    readonly property string icon: Notifications.icon(notification)

    signal dismissed

    width: 360
    height: 48

    ListRow {
        anchors.fill: parent
        textX: 40
        overline: card.notification?.appName ?? ""
        title: card.notification?.summary ?? ""
        subtitle: card.notification?.body ?? ""

        IconImage {
            visible: card.icon !== ""
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            implicitSize: 24
            source: card.icon
        }

        Rectangle {
            visible: card.icon === ""
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            width: 24
            height: 24
            radius: 12
            color: IslandTheme.card

            IslandText {
                anchors.centerIn: parent
                text: (card.notification?.appName || "?")[0].toUpperCase()
                font.weight: Font.DemiBold
            }
        }
    }

    // Clicking runs the app's default action, if it has one, and clears the notification.
    MouseArea {
        id: area

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            const n = card.notification;
            if (!n)
                return;
            n.actions.find(action => action.identifier === "default")?.invoke();
            n.dismiss();
            card.dismissed();
        }
    }
}
