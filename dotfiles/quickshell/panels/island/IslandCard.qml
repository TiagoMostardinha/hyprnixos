import QtQuick

Rectangle {
    property string side: "center"
    property int drop: 4
    property int gap: 14

    // Asks the island to switch to another card, e.g. open("Calendar").
    signal open(string card)

    radius: IslandTheme.radiusCard
    color: IslandTheme.pill
}
