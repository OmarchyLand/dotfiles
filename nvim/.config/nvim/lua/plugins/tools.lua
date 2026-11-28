-- Git blame, GitHub (octo), and autosave.
---@type LazySpec
return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim", "nvim-tree/nvim-web-devicons" },
    opts = { picker = "snacks", enable_builtin = true },
    init = function()
      local lines = {
        " Octo cheat sheet          (q / Esc to close)",
        "",
        " OPEN",
        "   Space O o      Octo action picker",
        "   Space O p      list PRs (Enter to open)",
        "   :Octo pr edit N   open PR #N directly",
        "",
        " PR BUFFER",
        "   ,ca   add comment        ,pd   show diff",
        "   ,pf   changed files      ,po   checkout PR",
        "   ,pm   merge              ,pc   close",
        "",
        " REVIEW   (Space O r  /  :Octo review)",
        "   ]q / [q        next / prev file",
        "   ,e             focus file panel",
        "   ,b             toggle file panel",
        "   ,ca            comment on line/selection (save with :w)",
        "   ,sa            suggest a change",
        "   Space Space    mark file viewed",
        "",
        " SUBMIT   (:Octo review submit)",
        "   Ctrl-a  approve   Ctrl-m  comment   Ctrl-r  request changes",
        "   :Octo review resume / discard",
        "",
        " Can't approve your own PR. Press , in an Octo buffer for live keys.",
      }
      vim.api.nvim_create_user_command("OctoHelp", function()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false
        vim.bo[buf].bufhidden = "wipe"
        local width = 0
        for _, l in ipairs(lines) do
          width = math.max(width, vim.fn.strdisplaywidth(l))
        end
        width = width + 2
        local height = #lines
        vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          style = "minimal",
          border = "rounded",
          title = " 󰊤 Octo ",
          title_pos = "center",
        })
        for _, key in ipairs { "q", "<Esc>" } do
          vim.keymap.set("n", key, "<Cmd>close<CR>", { buffer = buf, nowait = true })
        end
      end, { desc = "Show Octo cheat sheet" })
    end,
    keys = {
      { "<Leader>O", desc = "󰊤 GitHub (Octo)" },
      { "<Leader>Oh", "<Cmd>OctoHelp<CR>", desc = "Octo cheat sheet" },
      { "<Leader>Oo", "<Cmd>Octo<CR>", desc = "Octo actions" },
      { "<Leader>Op", "<Cmd>Octo pr list<CR>", desc = "List PRs" },
      { "<Leader>Oi", "<Cmd>Octo issue list<CR>", desc = "List issues" },
      { "<Leader>Or", "<Cmd>Octo review<CR>", desc = "Review current PR" },
      { "<Leader>Os", "<Cmd>Octo search<CR>", desc = "Search GitHub" },
    },
  },

  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    opts = {},
    keys = { { "<Leader>gB", "<Cmd>BlameToggle<CR>", desc = "Toggle git blame" } },
    dependencies = {
      { "AstroNvim/astroui", opts = { status = { winbar = { enabled = { filetype = { "blame" } } } } } },
    },
  },

  {
    "okuuva/auto-save.nvim",
    event = { "User AstroFile", "InsertEnter" },
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        autocmds = {
          -- don't run format-on-save for autosaves
          autoformat_toggle = {
            {
              event = "User",
              pattern = "AutoSaveWritePre",
              desc = "Disable autoformat before saving",
              callback = function()
                vim.g.OLD_AUTOFORMAT = vim.g.autoformat
                vim.g.autoformat = false
                local old = {}
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.b[bufnr].autoformat then
                    table.insert(old, bufnr)
                    vim.b[bufnr].autoformat = false
                  end
                end
                vim.g.OLD_AUTOFORMAT_BUFFERS = old
              end,
            },
            {
              event = "User",
              pattern = "AutoSaveWritePost",
              desc = "Re-enable autoformat after saving",
              callback = function()
                vim.g.autoformat = vim.g.OLD_AUTOFORMAT
                for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
                  vim.b[bufnr].autoformat = true
                end
              end,
            },
          },
        },
      },
    },
    opts = {},
  },
}
