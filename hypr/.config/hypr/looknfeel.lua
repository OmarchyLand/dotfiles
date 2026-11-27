-- Change the default Omarchy look'n'feel.

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Movie-terminal look: no gaps, a thin border and a soft glow on the focused
-- window only, both in the active Omarchy theme's colors. Theme switches reload
-- Hyprland, which re-reads colors.toml here. Themes whose look depends on their
-- own window frame keep Omarchy's border and get no glow.
local themes_with_own_frame = { ["windows-3.1"] = true }
local theme_dir = os.getenv("HOME") .. "/.local/state/omarchy/current/"

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return "" end
  local s = f:read("a") or ""
  f:close()
  return s
end

local theme_name = read_file(theme_dir .. "theme.name"):match("^%s*(.-)%s*$")
local colors = read_file(theme_dir .. "theme/colors.toml")

-- "#82FB9C" from colors.toml -> "rgba(82fb9cAA)" for Hyprland.
local function theme_rgba(key, alpha)
  local hex = colors:match("\n%s*" .. key .. '%s*=%s*"#(%x%x%x%x%x%x)"')
  return hex and ("rgba(" .. hex:lower() .. alpha .. ")") or nil
end

if not themes_with_own_frame[theme_name] then
  local accent = theme_rgba("accent", "ff") or "rgba(82fb9cff)"
  local glow = theme_rgba("accent", "99") or "rgba(82fb9c99)"
  local background = theme_rgba("background", "ff") or "rgba(000000ff)"

  hl.config({
    general = {
      border_size = 1,
      gaps_in = 0,
      gaps_out = 0,
      col = {
        active_border = accent,
        -- Blend unfocused borders into the background so only the focused window is lit.
        inactive_border = background,
      },
    },
    decoration = {
      shadow = {
        enabled = true,
        range = 14,
        render_power = 3,
        offset = "0 0",
        color = glow,
        color_inactive = "rgba(00000000)",
      },
    },
  })
end
