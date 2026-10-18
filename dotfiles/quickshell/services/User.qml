pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    readonly property string name: Quickshell.env("USER")
    readonly property string realName: passwd.text().split("\n").map(line => line.split(":")).find(fields => fields[0] === name)?.[4] || name
    readonly property url avatar: "file:///var/lib/AccountsService/icons/" + name

    FileView {
        id: passwd
        path: "/etc/passwd"
        blockLoading: true
    }
}
