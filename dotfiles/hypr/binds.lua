local mod         = "SUPER"
local terminal    = "uwsm app -- kitty"
local fileManager = "uwsm app -- thunar"
local menu        = "qs ipc call island launcher"

hl.bind(mod .. " + Q",     hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + C",     hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mod .. " + M",     hl.dsp.exec_cmd("qs ipc call island gateway"))
hl.bind(mod .. " + E",     hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + V",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + F",     hl.dsp.window.fullscreen())
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + TAB",   hl.dsp.exec_cmd("qs ipc call island workspaces"))
hl.bind(mod .. " + L",     hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + P",     hl.dsp.window.pseudo())
hl.bind(mod .. " + J",     hl.dsp.layout("togglesplit"))

hl.bind("Print",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 5 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
