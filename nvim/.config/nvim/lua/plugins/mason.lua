-- Language servers, formatters and debuggers installed through Mason.
-- Kotlin tools need a JDK on PATH to run.
---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "pyright",
        "ruff",
        "debugpy",
        "gopls",
        "typescript-language-server",
        "eslint-lsp",
        "yaml-language-server",
        "standardrb",
        "kotlin-language-server",
        "ktlint",
        "tree-sitter-cli",
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    -- only source is ktlint, so don't load none-ls (~27ms) for every other file
    event = function() return {} end,
    ft = { "kotlin" },
    opts = function(_, opts)
      local null_ls = require "null-ls"
      -- ktlint picks the nearest .editorconfig
      local function ktlint_args(params)
        local editorconfig = vim.fs.find(".editorconfig", { upward = true, path = params.bufname })[1]
        return editorconfig and { "--editorconfig=" .. editorconfig } or {}
      end
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        null_ls.builtins.formatting.ktlint.with { extra_args = ktlint_args },
        null_ls.builtins.diagnostics.ktlint.with { extra_args = ktlint_args },
      })
    end,
  },
}
