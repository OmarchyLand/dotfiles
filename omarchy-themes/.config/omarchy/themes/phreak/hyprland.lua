-- Phreak window frames: a magenta-to-cyan neon tube around the focused window,
-- a dim violet wire around the rest, hard square corners, a coloured glow in
-- place of a drop shadow, and snappy "terminal" animations.
local active_border_color = { colors = { "rgb(ff2bd6)", "rgb(7a5cff)", "rgb(00f0ff)" }, angle = 45 }
local inactive_border_color = { colors = { "rgba(2a2350cc)", "rgba(1a1638cc)" }, angle = 45 }

hl.config({
  general = {
    border_size = 2,
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  decoration = {
    rounding = 0,
    shadow = {
      enabled = true,
      range = 18,
      render_power = 2,
      color = "rgba(ff2bd655)",
      color_inactive = "rgba(00000000)",
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
    groupbar = {
      text_color = "rgb(07051a)",
      text_color_inactive = "rgb(a6e9ff)",
      col = {
        active = "rgb(ff2bd6)",
        inactive = "rgb(140f30)",
      },
    },
  },
})
