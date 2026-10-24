local colors = require("colors")

require("binds")
require("rules")

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 4,
        border_size = 2,
        col = {
            active_border   = colors.accent,
            inactive_border = colors.inactive,
        },
    },

    decoration = {
        rounding = 0,
        shadow   = { enabled = false },
        blur     = { enabled = false },
    },

    animations = { enabled = false },

    dwindle = { preserve_split = true },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        allow_session_lock_restore = true,
    },

    input = { kb_layout = "pt" },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

pcall(dofile, os.getenv("HOME") .. "/.config/hypr/host.lua")
