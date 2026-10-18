# nixos-config

One flake for a NixOS laptop running Hyprland (Lua config) and a Quickshell desktop.
Rules for working in this repo: `docs/Context.md`.

## Layout

| Path | What |
| --- | --- |
| `flake.nix` | inputs + one `nixosConfigurations.<host>` line per laptop |
| `hosts/<name>/` | the only machine-specific config: hardware, boot, monitors |
| `modules/nixos/` | shared system config (`default.nix` imports all) |
| `modules/home/` | shared Home Manager config (`default.nix` imports all) |
| `dotfiles/hypr/` | Hyprland Lua + hypridle/hyprpaper, symlinked, reload on save |
| `dotfiles/quickshell/` | Quickshell config, symlinked to `~/.config/quickshell`; `greeter.qml` is the greetd login screen |
| `assets/` | desktop wallpaper, avatar (the login/lock wallpaper is in `dotfiles/quickshell/assets/`) |
| `docs/` | documentation only; not used by any config |

The repo must be cloned to `~/nixos-config` (dotfile links point there).

## Apply

```sh
nix flake check
nixos-rebuild build --flake .#latitude-7340
sudo nixos-rebuild switch --flake .#latitude-7340
```

## Login screen problems

The login screen is greetd running a small Hyprland with the Quickshell greeter.

- Its output goes to the journal: `journalctl -b -u greetd` and `journalctl -b -t greeter-hyprland`.
- If it doesn't appear, press Ctrl+Alt+F2, log in on the console, and run `sudo nixos-rebuild switch --rollback` (or fix the config and switch again).

## New laptop

1. Install NixOS, `git clone <repo> ~/nixos-config`.
2. `mkdir hosts/<new>` and `nixos-generate-config --show-hardware-config > hosts/<new>/hardware-configuration.nix`.
3. Copy `default.nix` and `home.nix` from an existing host. Change boot, hardware quirks and monitors (`hosts/<new>/home.nix` writes `~/.config/hypr/host.lua`). Keep the new machine's `stateVersion`s.
4. Add `<new> = mkHost "<new>";` to `nixosConfigurations` in `flake.nix`.
5. `git add .` then `sudo nixos-rebuild switch --flake .#<new>` and reboot.
