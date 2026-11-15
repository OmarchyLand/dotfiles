-- Omarchy integration.
--
-- Omarchy symlinks lua/plugins/theme.lua to the active theme's neovim.lua. That
-- file is written for LazyVim: it returns the colorscheme plugin spec plus
-- `{ "LazyVim/LazyVim", opts = { colorscheme = ... } }`. Disable the LazyVim
-- fragment so lazy never installs it, and read the colorscheme name from it
-- instead. omarchy-theme-hotreload.lua reads that same table on theme switches.

local function omarchy_colorscheme()
  local ok, spec = pcall(require, "plugins.theme")
  if not ok or type(spec) ~= "table" then return nil end
  for _, s in ipairs(spec) do
    if type(s) == "table" and s[1] == "LazyVim/LazyVim" and s.opts then return s.opts.colorscheme end
  end
end

return {
  { "LazyVim/LazyVim", enabled = false },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = function(_, opts) opts.colorscheme = omarchy_colorscheme() or "astrodark" end,
  },
}
