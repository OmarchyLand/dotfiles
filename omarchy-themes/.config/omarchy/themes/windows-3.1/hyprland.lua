-- Windows 3.1 window frames: a thick sizing border (navy when active, like the
-- title bar; grey when not), a 1px black outline, square corners, no blur,
-- and no animations — windows simply appear, as they did in 1992.
local active_border_color = "rgb(000080)"
local inactive_border_color = "rgb(808080)"

hl.config({
  general = {
    border_size = 4,
    gaps_in = 4,
    gaps_out = 8,
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  decoration = {
    rounding = 0,
    blur = { enabled = false },
    -- A sharp 1px shadow reads as the black line around a 3.1 window frame.
    shadow = {
      enabled = true,
      range = 1,
      render_power = 1,
      sharp = true,
      color = "rgb(000000)",
      color_inactive = "rgb(000000)",
    },
  },

  animations = { enabled = false },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
    groupbar = {
      gradients = true,
      gradient_rounding = 0,
      text_color = "rgb(ffffff)",
      text_color_inactive = "rgb(000000)",
      col = {
        active = "rgb(000080)",
        inactive = "rgb(ffffff)",
      },
    },
  },
})
