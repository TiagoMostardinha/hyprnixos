import QtQuick
import QtQuick.Shapes

Rectangle {
    id: card

    readonly property string side: "center"
    readonly property int drop: 6
    readonly property int gap: 20

    readonly property var apps: [
        { name: "About Xfce", description: "Information about the Xfce Desktop Environment" },
        { name: "Advanced Network Configuration", description: "Manage and change your network connection settings" },
        { name: "Alacritty", description: "Terminal" },
        { name: "auto-cpufreq", description: "" },
        { name: "Avahi SSH Server Browser", description: "Browse for Zeroconf-enabled SSH Servers" },
        { name: "Avahi VNC Server Browser", description: "Browse for Zeroconf-enabled VNC Servers" }
    ]
    readonly property int selected: 0

    width: 514
    height: 367
    radius: 30
    color: IslandTheme.pill

    Shape {
        x: 23 - 8
        y: 32 - 8
        width: 16
        height: 16
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: IslandTheme.fg2
            strokeWidth: 1.6
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            PathAngleArc { centerX: 7; centerY: 7; radiusX: 5; radiusY: 5; startAngle: 0; sweepAngle: 360 }
            PathMove { x: 10.8; y: 10.8 }
            PathLine { x: 14; y: 14 }
        }
    }

    Rectangle {
        x: 44
        y: 32 - height / 2
        width: 1.5
        height: 18
        color: IslandTheme.fg
    }

    Text {
        x: 46
        y: 32 - height / 2
        text: "Search..."
        color: IslandTheme.fg3
        font.family: IslandTheme.font
        font.pixelSize: 15
    }

    Rectangle {
        x: 14
        y: 60
        width: card.width - 28
        height: 1
        color: IslandTheme.line
    }

    Column {
        x: 14
        y: 72
        width: card.width - 28

        Repeater {
            model: card.apps

            Rectangle {
                id: row

                required property var modelData
                required property int index

                readonly property bool isSelected: index === card.selected

                width: parent.width
                height: 46.5
                radius: 10
                color: isSelected ? IslandTheme.card2 : "transparent"

                Rectangle {
                    visible: row.isSelected
                    x: 2
                    anchors.verticalCenter: parent.verticalCenter
                    width: 3
                    height: 22
                    radius: 1.5
                    color: IslandTheme.fg
                }

                Rectangle {
                    x: 12
                    anchors.verticalCenter: parent.verticalCenter
                    width: 32
                    height: 32
                    radius: 9
                    color: IslandTheme.card
                }

                Column {
                    x: 56
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 1

                    Text {
                        text: row.modelData.name
                        color: IslandTheme.fg
                        font.family: IslandTheme.font
                        font.pixelSize: 15
                        font.weight: Font.Medium
                    }

                    Text {
                        visible: text !== ""
                        text: row.modelData.description
                        color: IslandTheme.fg2
                        font.family: IslandTheme.font
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
