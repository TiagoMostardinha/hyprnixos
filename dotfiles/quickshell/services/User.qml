pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// The person shown on the login and lock screens.
// The greeter runs as the greeter user, so it is told who to show with
// QS_LOGIN_USER (modules/nixos/greeter.nix); the desktop shell uses $USER.
Singleton {
    id: root

    readonly property string name: Quickshell.env("QS_LOGIN_USER") || Quickshell.env("USER") || ""
    // Full name from the passwd GECOS field, falling back to the login name.
    readonly property string realName: {
        for (const line of passwd.text().split("\n")) {
            const fields = line.split(":");
            if (fields[0] === root.name)
                return fields[4].split(",")[0] || root.name;
        }
        return root.name;
    }
    // Installed by modules/nixos/greeter.nix.
    readonly property url avatar: "file:///var/lib/AccountsService/icons/" + name

    FileView {
        id: passwd
        path: "/etc/passwd"
        blockLoading: true
    }
}
