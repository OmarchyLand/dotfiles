-- Windows 98 window frames: the border carries the title-bar gradient (navy
-- fading to blue when active, grey fading to silver when not), square
-- corners, a hard 1px dark edge, no blur, and no animations.
local active_border_color = { colors = { "rgb(000080)", "rgb(1084d0)" }, angle = 0 }
local inactive_border_color = { colors = { "rgb(808080)", "rgb(b5b5b5)" }, angle = 0 }

hl.config({
  general = {
    border_size = 4,
    gaps_in = 3,
    gaps_out = 6,
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  decoration = {
    rounding = 0,
    blur = { enabled = false },
    -- A sharp 1px shadow reads as the dark outer edge of a 98 window frame.
    shadow = {
      enabled = true,
      range = 1,
      render_power = 1,
      sharp = true,
      color = "rgb(000000)",
      color_inactive = "rgb(404040)",
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
      text_color_inactive = "rgb(c0c0c0)",
      col = {
        active = "rgb(000080)",
        inactive = "rgb(808080)",
      },
    },
  },
})
