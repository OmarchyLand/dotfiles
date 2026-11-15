-- Core options, treesitter and the meh-key (Ctrl+Alt+Shift) mappings.
-- See `:h astrocore`.

-- Debugprint the word under the cursor; in Go, add the `os` import it needs first.
local function debugprint_variable()
  local word = vim.fn.expand "<cword>"
  if word == nil or word == "" then
    vim.notify("Put the cursor on a variable first", vim.log.levels.ERROR)
    return
  end
  if vim.bo.filetype == "go" then
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local has_os = false
    for _, line in ipairs(lines) do
      if line:match '^%s*import%s+"os"' or line:match '^%s*"os"%s*$' then
        has_os = true
        break
      end
    end
    if not has_os then
      local block_start, block_end
      for i, line in ipairs(lines) do
        if line:match "^%s*import%s*%(" then
          block_start = i
          for j = i + 1, #lines do
            if lines[j]:match "^%s*%)%s*$" then
              block_end = j
              break
            end
          end
          break
        end
      end
      if block_start and block_end then
        vim.api.nvim_buf_set_lines(bufnr, block_start, block_start, false, { '\t"os"' })
      else
        for i, line in ipairs(lines) do
          if line:match "^%s*package%s+%S+" then
            vim.api.nvim_buf_set_lines(bufnr, i, i, false, { "", "import (", '\t"os"', ")" })
            break
          end
        end
      end
    end
  end
  vim.cmd "normal! viw"
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g?v", true, false, true), "x", false)
end

-- Snacks marks picker limited to letter marks; pressing a letter jumps straight to it.
local function letter_marks()
  Snacks.picker.marks {
    transform = function(item) return item.label and item.label:match "^%a$" and item or false end,
    on_show = function(picker)
      for c = string.byte "a", string.byte "z" do
        local letter = string.char(c)
        for _, l in ipairs { letter, letter:upper() } do
          vim.keymap.set("n", l, function()
            for _, item in ipairs(picker:items()) do
              if item.label == l then
                picker:action("confirm", item)
                vim.cmd "normal! zz"
                return
              end
            end
          end, { buffer = picker.list.win.buf, nowait = true })
        end
      end
    end,
  }
end

-- Load every lazy-loaded colorscheme so the picker can list them all.
local function pick_colorscheme()
  local ok, themes = pcall(require, "plugins.all-themes")
  if ok and type(themes) == "table" then
    local names = {}
    for _, spec in ipairs(themes) do
      local name = type(spec) == "table" and (spec.name or spec[1]) or spec
      if type(name) == "string" then table.insert(names, (name:gsub("^.*/", ""))) end
    end
    require("lazy").load { plugins = names }
  end
  Snacks.picker.colorschemes()
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = false, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = false,
      underline = true,
    },
    treesitter = {
      highlight = true,
      indent = true,
      auto_install = true,
      ensure_installed = { "lua", "vim", "javascript", "jsdoc", "typescript", "tsx" },
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = true,
      },
      g = {
        -- No remote plugins are used; probing for python3/pynvim alone cost ~85ms per .py file
        loaded_python3_provider = 0,
        loaded_ruby_provider = 0,
        loaded_perl_provider = 0,
        loaded_node_provider = 0,
      },
    },
    mappings = {
      n = {
        ["<C-d>"] = { "<C-d>zz", desc = "Half-page down and center" },
        ["<C-u>"] = { "<C-u>zz", desc = "Half-page up and center" },

        -- meh = Ctrl+Alt+Shift
        ["<C-A-S-f>"] = { function() Snacks.picker.files() end, desc = "Find files (meh+f)" },
        ["<C-A-S-s>"] = { function() Snacks.picker.smart() end, desc = "Smart find (meh+s)" },
        ["<C-A-S-w>"] = { function() Snacks.picker.grep() end, desc = "Find words (meh+w)" },
        ["<C-A-S-;>"] = {
          function()
            local pattern = vim.fn.input "Glob pattern: "
            if pattern ~= "" then Snacks.picker.grep { glob = pattern } end
          end,
          desc = "Find words by glob (meh+;)",
        },
        ["<C-A-S-b>"] = {
          function()
            local next_key = { ["<C-A-S-b>"] = { "list_down", mode = { "i", "n" } } }
            Snacks.picker.buffers { focus = "list", win = { input = { keys = next_key }, list = { keys = next_key } } }
          end,
          desc = "Find buffers (meh+b)",
        },
        ["<C-A-S-o>"] = { function() Snacks.picker.lsp_symbols() end, desc = "Symbols (meh+o)" },
        ["<C-A-S-d>"] = { letter_marks, desc = "Find letter marks (meh+d)" },
        ["<C-A-S-p>"] = { debugprint_variable, desc = "Debugprint variable below (meh+p)" },
        ["<C-A-S-m>"] = { "<Cmd>Grapple toggle_tags<CR>", desc = "Grapple menu (meh+m)" },
        ["<C-A-S-z>"] = { function() Snacks.zen() end, desc = "Toggle Zen Mode (meh+z)" },
        ["<C-A-S-a>"] = { "ggVG", desc = "Select all (meh+a)" },
        ["<C-A-S-l>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer (meh+l)" },
        ["<C-A-S-h>"] = {
          function() require("astrocore.buffer").nav(-vim.v.count1) end,
          desc = "Previous buffer (meh+h)",
        },
        ["<D-e>"] = { function() Snacks.picker.buffers() end, desc = "Find buffers" },

        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(function(bufnr) require("astrocore.buffer").close(bufnr) end)
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>bo"] = {
          function() require("astrocore.buffer").close_all(true) end,
          desc = "Close all buffers except current",
        },
        ["<Leader>uT"] = { pick_colorscheme, desc = "Pick colorscheme" },
        ["<Leader>gu"] = { function() vim.ui.open(vim.fn.expand "<cfile>") end, desc = "Open URL under cursor" },
      },
      v = {
        ["<C-A-S-x>"] = { "x", desc = "Cut selection (meh+x)" },
      },
    },
  },
}
