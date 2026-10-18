import QtQuick
import "../theme"
import "../services"

// Date above a large 24h clock. Fills the screen; positions are fractions of its height.
Item {
    id: root

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.dateY - height / 2
        text: Qt.locale("en_US").toString(Time.date, "dddd, d MMMM")
        color: Theme.text
        font.family: Theme.fontFamily
        font.weight: Font.DemiBold
        font.pixelSize: root.height * Theme.dateSize
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * Theme.clockY - height / 2
        text: Qt.locale("en_US").toString(Time.date, "HH:mm")
        color: Theme.textClock
        font.family: Theme.fontFamily
        font.weight: Font.Bold
        font.pixelSize: root.height * Theme.clockSize
    }
}
