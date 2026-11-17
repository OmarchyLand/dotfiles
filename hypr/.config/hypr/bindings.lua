-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })

-- Remove the default Omarchy reminder bindings
hl.unbind("SUPER + CTRL + R")         -- Set reminder
hl.unbind("SUPER + CTRL + ALT + R")   -- Show reminders
hl.unbind("SUPER + SHIFT + CTRL + R") -- Clear reminders

-- 2x3 window grid on the active workspace (press again to return to tiling).
-- Replaced the hyprexpo workspace overview that used to live on SUPER+D.
local grid = require("hypr.grid")
o.rebind("SUPER + D", "Toggle 2x3 window grid", function() grid.toggle() end)
-- While gridded these scroll the grid a column; otherwise they move focus as usual.
o.rebind("SUPER + RIGHT", "Focus right / scroll grid right", function() grid.right() end)
o.rebind("SUPER + LEFT", "Focus left / scroll grid left", function() grid.left() end)

-- Reload aliases in all open bash shells (on their next prompt)
o.bind("SUPER + ALT + R", "Reload shell aliases", "reload-shells")
