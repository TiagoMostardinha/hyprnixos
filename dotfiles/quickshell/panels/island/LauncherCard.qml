import QtQuick
import Quickshell
import Quickshell.Widgets

IslandCard {
    id: card

    // Visible apps sorted by name; typing keeps those whose name, generic name, keywords or comment
    // contain the query, with names that start with it first.
    readonly property var apps: DesktopEntries.applications.values
        .filter(app => !app.noDisplay)
        .sort((a, b) => a.name.localeCompare(b.name))
    readonly property var matches: {
        const query = search.text.trim().toLowerCase();
        if (query === "")
            return apps;
        const hit = app => [app.name, app.genericName, app.comment, ...app.keywords].some(field => field?.toLowerCase().includes(query));
        const starts = app => app.name.toLowerCase().startsWith(query);
        const found = apps.filter(hit);
        return found.filter(starts).concat(found.filter(app => !starts(app)));
    }

    function launch(app) {
        if (!app)
            return;
        Quickshell.execDetached(["uwsm", "app", "--", app.id + ".desktop"]);
        card.open("Idle");
    }

    width: 440
    height: 258

    Component.onCompleted: search.forceActiveFocus()

    PathGlyph {
        x: 12
        y: 20 - height / 2
        color: IslandTheme.fg2
        stroke: "M 12 7 A 5 5 0 1 1 2 7 A 5 5 0 1 1 12 7 Z M 10.8 10.8 L 14 14"
    }

    IslandText {
        visible: search.text === ""
        x: 33
        y: 20 - height / 2
        text: "Search..."
        tone: "muted"
        font.pixelSize: IslandTheme.title
    }

    TextInput {
        id: search

        x: 33
        y: 20 - height / 2
        width: card.width - x - 12
        color: IslandTheme.fg
        selectionColor: IslandTheme.card2
        font.family: IslandTheme.font
        font.pixelSize: IslandTheme.title
        clip: true

        cursorDelegate: Rectangle {
            width: 1.5
            color: IslandTheme.fg
        }

        onTextChanged: list.currentIndex = 0
        Keys.onUpPressed: list.decrementCurrentIndex()
        Keys.onDownPressed: list.incrementCurrentIndex()
        Keys.onReturnPressed: card.launch(card.matches[list.currentIndex])
        Keys.onEnterPressed: card.launch(card.matches[list.currentIndex])
    }

    Rectangle {
        x: 10
        y: 40
        width: card.width - 20
        height: 1
        color: IslandTheme.line
    }

    ListView {
        id: list

        x: 10
        y: 46
        width: card.width - 20
        height: card.height - y - 6
        clip: true
        model: card.matches
        highlightMoveDuration: 0

        delegate: ListRow {
            id: row

            required property var modelData
            required property int index

            width: ListView.view.width
            height: 34
            radius: IslandTheme.radiusButton
            highlight: ListView.isCurrentItem ? "subtle" : "none"
            textX: 38
            title: modelData.name
            titleWeight: Font.Medium
            subtitle: modelData.comment || modelData.genericName

            IconImage {
                x: 10
                anchors.verticalCenter: parent.verticalCenter
                implicitSize: 20
                source: Quickshell.iconPath(row.modelData.icon, "application-x-executable")
            }

            MouseArea {
                anchors.fill: parent
                onClicked: card.launch(row.modelData)
            }
        }
    }
}
