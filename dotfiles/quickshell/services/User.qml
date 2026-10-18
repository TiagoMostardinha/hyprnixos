pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// The person shown on the login and lock screens. The greeter runs as the
// greeter user, so it gets the name from QS_LOGIN_USER (modules/nixos/greeter.nix).
Singleton {
    readonly property string name: Quickshell.env("QS_LOGIN_USER") || Quickshell.env("USER")
    // Full name: GECOS field of /etc/passwd.
    readonly property string realName: passwd.text().split("\n").map(line => line.split(":")).find(fields => fields[0] === name)?.[4] || name
    // Installed by modules/nixos/greeter.nix.
    readonly property url avatar: "file:///var/lib/AccountsService/icons/" + name

    FileView {
        id: passwd
        path: "/etc/passwd"
        blockLoading: true
    }
}
