import QtQuick
import QtQuick.Shapes

Rectangle {
    id: card

    readonly property string side: "center"
    readonly property int drop: 6
    readonly property int gap: 20

    width: 430
    height: 267
    radius: 30
    color: IslandTheme.pill

    component LockBadge: Rectangle {
        width: 30
        height: 30
        radius: 15
        color: IslandTheme.fg

        Shape {
            anchors.centerIn: parent
            width: 16
            height: 16
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: IslandTheme.pill
                strokeWidth: 1.5
                fillColor: "transparent"
                PathSvg { path: "M 5 7.5 V 5 A 3 3 0 0 1 11 5 V 7.5" }
            }

            ShapePath {
                strokeColor: "transparent"
                fillColor: IslandTheme.pill
                PathRectangle { x: 3.5; y: 7.5; width: 9; height: 7; radius: 1.5 }
            }
        }
    }

    component Button: Rectangle {
        property alias label: buttonText.text
        property bool primary: false

        height: 31
        radius: height / 2
        color: primary ? IslandTheme.fg : IslandTheme.card2

        Text {
            id: buttonText

            anchors.centerIn: parent
            color: parent.primary ? IslandTheme.pill : IslandTheme.fg
            font.family: IslandTheme.font
            font.pixelSize: 13
            font.weight: Font.DemiBold
        }
    }

    LockBadge {
        x: 14
        y: 15
    }

    Text {
        x: 57
        y: 30 - height / 2
        text: "Authentication required"
        color: IslandTheme.fg
        font.family: IslandTheme.font
        font.pixelSize: 16
        font.weight: Font.Medium
    }

    Rectangle {
        x: 15
        y: 56
        width: card.width - 30
        height: 73
        radius: 14
        color: IslandTheme.card
        border.color: IslandTheme.card2
        border.width: 1

        Column {
            x: 11
            y: 9
            width: parent.width - 22
            spacing: 2

            Text {
                width: parent.width
                text: "Authentication is needed to run `/usr/bin/true' as the super user"
                wrapMode: Text.WordWrap
                color: IslandTheme.fg
                font.family: IslandTheme.font
                font.pixelSize: 13
                font.weight: Font.DemiBold
            }

            Text {
                text: "org.freedesktop.policykit.exec"
                color: IslandTheme.fg2
                font.family: IslandTheme.font
                font.pixelSize: 11
            }
        }
    }

    Text {
        x: 15
        y: 148 - height / 2
        text: "Password"
        color: IslandTheme.fg3
        font.family: IslandTheme.font
        font.pixelSize: 11
    }

    Rectangle {
        x: 15
        y: 169
        width: card.width - 30
        height: 40
        radius: height / 2
        color: IslandTheme.pill
        border.color: IslandTheme.fg3
        border.width: 1

        LockBadge {
            x: 5
            anchors.verticalCenter: parent.verticalCenter
        }

        Row {
            x: 47
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "••••••••••"
                color: IslandTheme.fg
                font.family: IslandTheme.font
                font.pixelSize: 12
                font.letterSpacing: 1
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 1.5
                height: 18
                color: IslandTheme.fg
            }
        }
    }

    Button {
        x: 224
        y: 222
        width: 73
        label: "Cancel"
    }

    Button {
        x: 305
        y: 222
        width: 111
        label: "Authenticate"
        primary: true
    }
}
