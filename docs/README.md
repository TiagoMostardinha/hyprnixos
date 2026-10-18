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
| `dotfiles/quickshell/` | Quickshell config, symlinked to `~/.config/quickshell` |
| `assets/` | wallpaper, lock/login wallpaper, avatar |
| `docs/` | documentation only; not used by any config |

The repo must be cloned to `~/nixos-config` (dotfile links point there).

## Apply

```sh
nix flake check
nixos-rebuild build --flake .#latitude-7340
sudo nixos-rebuild switch --flake .#latitude-7340
```

## New laptop

1. Install NixOS, `git clone <repo> ~/nixos-config`.
2. `mkdir hosts/<new>` and `nixos-generate-config --show-hardware-config > hosts/<new>/hardware-configuration.nix`.
3. Copy `default.nix` and `home.nix` from an existing host. Change boot, hardware quirks and monitors (`hosts/<new>/home.nix` writes `~/.config/hypr/host.lua`). Keep the new machine's `stateVersion`s.
4. Add `<new> = mkHost "<new>";` to `nixosConfigurations` in `flake.nix`.
5. `git add .` then `sudo nixos-rebuild switch --flake .#<new>` and reboot.
