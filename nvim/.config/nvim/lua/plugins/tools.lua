-- Git blame and autosave.
---@type LazySpec
return {
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
