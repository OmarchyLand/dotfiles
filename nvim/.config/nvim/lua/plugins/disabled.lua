-- AstroNvim defaults turned off to keep file-open time down.
---@type LazySpec
return {
  { "brenoprata10/nvim-highlight-colors", enabled = false }, -- inline #rrggbb colouring, ~10ms per file
  { "folke/todo-comments.nvim", enabled = false }, -- TODO/FIXME highlighting, ~7ms per file
}
