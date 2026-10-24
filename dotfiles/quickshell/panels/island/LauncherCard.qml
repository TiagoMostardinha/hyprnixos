import QtQuick

IslandCard {
    id: card

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

    PathGlyph {
        x: 23 - 8
        y: 32 - 8
        color: IslandTheme.fg2
        strokeWidth: 1.6
        stroke: "M 12 7 A 5 5 0 1 1 2 7 A 5 5 0 1 1 12 7 Z M 10.8 10.8 L 14 14"
    }

    Rectangle {
        x: 44
        y: 32 - height / 2
        width: 1.5
        height: 18
        color: IslandTheme.fg
    }

    IslandText {
        x: 46
        y: 32 - height / 2
        text: "Search..."
        tone: "muted"
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

            ListRow {
                required property var modelData
                required property int index

                width: parent.width
                height: 46.5
                radius: 10
                highlight: index === card.selected ? "subtle" : "none"
                textX: 56
                spacing: 1
                title: modelData.name
                titleSize: 15
                titleWeight: Font.Medium
                subtitle: modelData.description
                subtitleSize: 12

                Rectangle {
                    x: 12
                    anchors.verticalCenter: parent.verticalCenter
                    width: 32
                    height: 32
                    radius: 9
                    color: IslandTheme.card
                }
            }
        }
    }
}
