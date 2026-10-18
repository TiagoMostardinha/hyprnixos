pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// The person shown on the lock screen.
Singleton {
    readonly property string name: Quickshell.env("USER")
    // Full name: GECOS field of /etc/passwd.
    readonly property string realName: passwd.text().split("\n").map(line => line.split(":")).find(fields => fields[0] === name)?.[4] || name
    // Installed by modules/nixos/sddm (the same avatar SDDM shows).
    readonly property url avatar: "file:///var/lib/AccountsService/icons/" + name

    FileView {
        id: passwd
        path: "/etc/passwd"
        blockLoading: true
    }
}
