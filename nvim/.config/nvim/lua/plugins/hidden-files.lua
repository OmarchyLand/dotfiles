-- Show hidden (dot) files by default in the snacks file/grep pickers.
-- (The explorer is yazi.nvim, which picks up show_hidden from yazi.toml.)
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
      },
    },
  },
}
