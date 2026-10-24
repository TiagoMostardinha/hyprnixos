import QtQuick

Text {
    property real line: NaN
    property string tone: "primary"

    color: tone === "secondary" ? IslandTheme.fg2 : tone === "muted" ? IslandTheme.fg3 : IslandTheme.fg
    font.family: IslandTheme.font

    Binding on y {
        when: !isNaN(line)
        value: line - baselineOffset
    }
}
