//@ pragma IconTheme Colloid-Dark

import Quickshell
import "panels/greeter"

// Entry point of the login greeter (run by greetd: modules/nixos/greeter.nix).
// Lives next to shell.qml (the desktop shell) because Quickshell only resolves
// imports inside the entry file's folder.
ShellRoot {
    Greeter {}
}
