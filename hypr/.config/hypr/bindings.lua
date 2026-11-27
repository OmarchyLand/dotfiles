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

-- Window grid on the active workspace: 2x3, cells split as windows are added
-- (press again to return to tiling).
-- Replaced the hyprexpo workspace overview that used to live on SUPER+D.
local grid = require("hypr.grid")
o.rebind("SUPER + D", "Toggle 2x3 window grid", function() grid.toggle() end)
-- While gridded these move focus to the neighbouring cell; otherwise as usual.
o.rebind("SUPER + LEFT", "Focus left (grid aware)", function() grid.focus("l") end)
o.rebind("SUPER + RIGHT", "Focus right (grid aware)", function() grid.focus("r") end)
o.rebind("SUPER + UP", "Focus up (grid aware)", function() grid.focus("u") end)
o.rebind("SUPER + DOWN", "Focus down (grid aware)", function() grid.focus("d") end)
-- While gridded these swap with the neighbouring cell; otherwise they swap windows as usual.
o.rebind("SUPER + SHIFT + LEFT", "Swap window / grid tile left", function() grid.swap("l") end)
o.rebind("SUPER + SHIFT + RIGHT", "Swap window / grid tile right", function() grid.swap("r") end)
o.rebind("SUPER + SHIFT + UP", "Swap window / grid tile up", function() grid.swap("u") end)
o.rebind("SUPER + SHIFT + DOWN", "Swap window / grid tile down", function() grid.swap("d") end)

-- Reload aliases in all open bash shells (on their next prompt)
o.bind("SUPER + ALT + R", "Reload shell aliases", "reload-shells")

-- flea --default: begin. Written by `flea --default`; `flea --default off` removes the block whole.
hl.unbind("SUPER + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = 'flea --gui' })
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { launch = 'flea --gui "$(omarchy-cmd-terminal-cwd)"' })
-- flea --default: end.

-- flea --picker: begin. Written by `flea --picker`; `flea --picker off` removes the block whole.
o.window("com.thisisgm.flea.picker", { tag = "+floating-window" })
-- flea --picker: end.

-- herdr is uninstalled: drop its default bindings. Remove if you reinstall it.
hl.unbind("SUPER + CTRL + RETURN")
hl.unbind("SUPER + CTRL + K")

-- Show/hide the tmux status bar (it sits at the top; see tmux.conf). Super never
-- reaches tmux through the terminal, so Hyprland sends the command instead.
-- Replaces the default Theme menu binding (Theme menu is still on SUPER + CTRL + T).
o.rebind("SUPER + SHIFT + CTRL + SPACE", "Toggle tmux status bar",
  [[tmux if -F '#{==:#{status},off}' 'set -g status on' 'set -g status off']])
