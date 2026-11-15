-- Text editing helpers.
---@type LazySpec
return {
  -- d/c/x no longer clobber the yank register (X still cuts)
  {
    "gbprod/cutlass.nvim",
    event = "VeryLazy",
    config = function()
      require("cutlass").setup { exclude = { "X" } }
      vim.keymap.set("n", "X", '"_X', { noremap = true, silent = true })
    end,
  },

  {
    "andrewferrier/debugprint.nvim",
    cmd = { "ToggleCommentDebugPrints", "DeleteDebugPrints", "ResetDebugPrintsCounter", "SearchDebugPrints" },
    keys = {
      { "g?", mode = { "n", "x" } },
      { "<C-G>", mode = "i" },
    },
    opts = {
      keymaps = {
        normal = {
          plain_below = "g?p",
          plain_above = "g?P",
          variable_below = "g?v",
          variable_above = "g?V",
          variable_below_alwaysprompt = "",
          variable_above_alwaysprompt = "",
          surround_plain = "g?sp",
          surround_variable = "g?sv",
          surround_variable_alwaysprompt = "",
          textobj_below = "g?o",
          textobj_above = "g?O",
          textobj_surround = "g?so",
          toggle_comment_debug_prints = "",
          delete_debug_prints = "",
        },
        insert = { plain = "<C-G>p", variable = "<C-G>v" },
        visual = { variable_below = "g?v", variable_above = "g?V" },
      },
      commands = {
        toggle_comment_debug_prints = "ToggleCommentDebugPrints",
        delete_debug_prints = "DeleteDebugPrints",
        reset_debug_prints_counter = "ResetDebugPrintsCounter",
        search_debug_prints = "SearchDebugPrints",
      },
    },
  },

  {
    "Wansmer/treesj",
    keys = { { "<Leader>jt", "<Cmd>TSJToggle<CR>", desc = "Toggle Split/Join" } },
    opts = { use_default_keymaps = false },
  },

  -- <CR> expands selection by treesitter node
  { "sustech-data/wildfire.nvim", event = "User AstroFile", opts = {} },

  {
    "matze/vim-move",
    keys = {
      { "<C-A-S-j>", "<Plug>MoveLineDown", desc = "Move line down (meh+j)" },
      { "<C-A-S-k>", "<Plug>MoveLineUp", desc = "Move line up (meh+k)" },
      { "<C-A-S-j>", "<Plug>MoveBlockDown", mode = "v", desc = "Move block down (meh+j)" },
      { "<C-A-S-k>", "<Plug>MoveBlockUp", mode = "v", desc = "Move block up (meh+k)" },
    },
    init = function() vim.g.move_map_keys = 0 end,
  },
}
