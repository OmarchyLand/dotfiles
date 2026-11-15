-- LSP behaviour. See `:h astrolsp`.
---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = { "python", "go", "kotlin" },
      },
      disabled = { "kotlin_language_server" }, -- ktlint (none-ls) formats Kotlin instead
      timeout_ms = 1000,
    },
    -- passed to `vim.lsp.config`
    config = {
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ["https://api.cerbos.dev/latest/cerbos/policy/v1/Policy.schema.json"] = "/cerbos/*",
              ["https://api.cerbos.dev/latest/cerbos/policy/v1/TestSuite.schema.json"] = "/cerbos/**/*_test.yaml",
              ["https://api.cerbos.dev/latest/cerbos/policy/v1/TestFixture/Resources.schema.json"] = "/cerbos/**/testdata/resources.yaml",
              ["https://api.cerbos.dev/latest/cerbos/policy/v1/TestFixture/Principals.schema.json"] = "/cerbos/**/testdata/principals.yaml",
              ["https://api.cerbos.dev/latest/cerbos/policy/v1/TestFixture/AuxData.schema.json"] = "/cerbos/**/testdata/auxdata.yaml",
            },
          },
        },
      },
    },
    autocmds = {
      format_on_escape = {
        {
          event = "InsertLeave",
          desc = "Format buffer on leaving insert mode (python, go)",
          callback = function(args)
            local ft = vim.bo[args.buf].filetype
            if ft == "python" or ft == "go" then vim.lsp.buf.format { bufnr = args.buf, async = true } end
          end,
        },
      },
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    on_attach = function(client)
      -- Pyright provides hover for Python; ruff's would duplicate it
      if client.name == "ruff" then client.server_capabilities.hoverProvider = false end
    end,
  },
}
