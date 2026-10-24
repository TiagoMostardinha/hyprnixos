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

    width: 440
    height: 258

    PathGlyph {
        x: 12
        y: 20 - height / 2
        color: IslandTheme.fg2
        stroke: "M 12 7 A 5 5 0 1 1 2 7 A 5 5 0 1 1 12 7 Z M 10.8 10.8 L 14 14"
    }

    Rectangle {
        x: 31
        y: 20 - height / 2
        width: 1.5
        height: 15
        color: IslandTheme.fg
    }

    IslandText {
        x: 33
        y: 20 - height / 2
        text: "Search..."
        tone: "muted"
        font.pixelSize: IslandTheme.title
    }

    Rectangle {
        x: 10
        y: 40
        width: card.width - 20
        height: 1
        color: IslandTheme.line
    }

    Column {
        x: 10
        y: 46
        width: card.width - 20

        Repeater {
            model: card.apps

            ListRow {
                required property var modelData
                required property int index

                width: parent.width
                height: 34
                radius: IslandTheme.radiusButton
                highlight: index === card.selected ? "subtle" : "none"
                textX: 38
                title: modelData.name
                titleWeight: Font.Medium
                subtitle: modelData.description

                Rectangle {
                    x: 10
                    anchors.verticalCenter: parent.verticalCenter
                    width: 20
                    height: 20
                    radius: 6
                    color: IslandTheme.card
                }
            }
        }
    }
}
