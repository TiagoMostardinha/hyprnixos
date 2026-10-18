import QtQuick

Item {
    property real sh
    property string fontFamily
    property date now

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: sh * 0.107 - height / 2
        text: Qt.locale("en_US").toString(now, "dddd, d MMMM")
        color: "white"
        font.family: fontFamily
        font.weight: Font.DemiBold
        font.pixelSize: sh * 0.0254
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: sh * 0.185 - height / 2
        text: Qt.locale("en_US").toString(now, "HH:mm")
        color: Qt.rgba(1, 1, 1, 0.9)
        font.family: fontFamily
        font.weight: Font.Bold
        font.pixelSize: sh * 0.12
    }
}
