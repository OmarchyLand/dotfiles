-- Runs last, after all plugins are set up.

-- Omarchy's clipboard handling (Wayland / tmux / OSC 52 over SSH)
require("remote_clipboard").setup()
