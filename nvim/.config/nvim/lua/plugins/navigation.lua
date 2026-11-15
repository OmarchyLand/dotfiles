-- Moving around: flash, yazi (file explorer, replaces neo-tree), grapple, tmux.
---@type LazySpec
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      -- no dimming / match highlighting for f, t, F, T
      modes = { char = { highlight = { backdrop = false, matches = false } } },
    },
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote Flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "x", "o" }, desc = "Treesitter Search" },
      {
        "<Leader>s",
        function()
          require("flash").jump { search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" }
        end,
        mode = { "n", "x", "o" },
        desc = "Flash Line Start",
      },
      {
        "<C-A-S-g>",
        function()
          require("flash").jump { search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" }
        end,
        desc = "Flash Line Start (meh+g)",
      },
      {
        "<C-Space>",
        function() require("flash").treesitter { actions = { ["<C-Space>"] = "next", ["<BS>"] = "prev" } } end,
        mode = { "n", "x", "o" },
        desc = "Treesitter incremental selection",
      },
    },
  },

  -- `s` inside a snacks picker: flash-jump to a result
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = { input = { keys = { ["<A-s>"] = { "flash", mode = { "n", "i" } }, ["s"] = { "flash" } } } },
        actions = {
          flash = function(picker)
            require("flash").jump {
              pattern = "^",
              label = { after = { 0, 0 } },
              search = {
                mode = "search",
                exclude = {
                  function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list" end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            }
          end,
        },
      },
      scroll = { enabled = true }, -- smooth scrolling (replaces vim-smoothie)
      dashboard = { enabled = false }, -- no start page; yazi opens instead (see yazi spec below)
    },
  },

  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
    keys = {
      { "<Leader>e", "<Cmd>Yazi<CR>", mode = { "n", "v" }, desc = "Explorer Yazi (current file)" },
      { "<Leader>E", "<Cmd>Yazi cwd<CR>", desc = "Explorer Yazi (cwd)" },
      { "<Leader>-", "<Cmd>Yazi<CR>", mode = { "n", "v" }, desc = "Open yazi at the current file" },
      { "<Leader>Yc", "<Cmd>Yazi cwd<CR>", desc = "Open yazi in nvim's working directory" },
      { "<Leader>Yt", "<Cmd>Yazi toggle<CR>", desc = "Resume the last yazi session" },
      { "<C-Up>", "<Cmd>Yazi toggle<CR>", desc = "Resume last Yazi session" },
    },
    ---@type YaziConfig | {}
    opts = {
      open_for_directories = true, -- `nvim .` opens yazi
      keymaps = { show_help = "<F1>" },
      integrations = {
        grep_in_directory = "snacks.picker",
        grep_in_selected_files = "snacks.picker",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
      -- Plain `nvim` (no files, no stdin): start in yazi at the cwd instead of a start page
      local stdin = false
      vim.api.nvim_create_autocmd("StdinReadPre", { once = true, callback = function() stdin = true end })
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          if vim.fn.argc() == 0 and not stdin then
            vim.schedule(function() require("yazi").yazi(nil, vim.fn.getcwd()) end)
          end
        end,
      })
    end,
  },

  {
    "cbochs/grapple.nvim",
    cmd = "Grapple",
    opts = { scope = "global" },
    keys = {
      { "<Leader>mm", "<Cmd>Grapple toggle_tags<CR>", desc = "Grapple menu" },
      { "<Leader>ma", "<Cmd>Grapple tag<CR>", desc = "Grapple tag" },
      { "<Leader>md", "<Cmd>Grapple untag<CR>", desc = "Grapple untag" },
      { "<Leader>mt", "<Cmd>Grapple toggle<CR>", desc = "Grapple toggle" },
      { "<Leader>mn", "<Cmd>Grapple cycle forward<CR>", desc = "Grapple next" },
      { "<Leader>mp", "<Cmd>Grapple cycle backward<CR>", desc = "Grapple previous" },
      { "<Leader>mx", "<Cmd>Grapple reset<CR>", desc = "Grapple reset" },
    },
  },

  -- <C-h/j/k/l> across nvim splits and tmux panes
  { "christoomey/vim-tmux-navigator", lazy = false },
}
