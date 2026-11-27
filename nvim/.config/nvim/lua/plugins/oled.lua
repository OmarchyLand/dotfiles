-- OLED: every dark colorscheme gets pure #000000 backgrounds.
--
-- Colorschemes like catppuccin, gruvbox, nord, kanagawa and tokyonight paint
-- their own dark greys/navies (editor, statusline, tabline, floats, sidebars,
-- completion menu), which ignore Omarchy's black colors.toml overlays. After
-- any colorscheme loads, every highlight group whose own background is dark
-- (relative luminance below DARK) gets it replaced by #000000.
--
-- Groups that mark something (Visual, Search, *Sel*, Diff*, MatchParen, ...)
-- keep their colour so selections stay visible. Linked groups are left alone:
-- they follow their target. Light colorschemes (background=light) are skipped.
--
-- This runs as AstroUI's `highlights.init`, which AstroUI applies inside its
-- ColorScheme autocmd right before it fires AstroColorScheme, the event that
-- makes heirline re-read its statusline/tabline colours. The bg is an explicit
-- #000000 rather than NONE because heirline falls back to AstroNvim's grey
-- defaults (#2c323c etc.) when a group has no bg.

local DARK = 0.06

local KEEP = {
  "Visual", "Search", "Sel", "Diff", "diff", "Match", "Substitute",
  "QuickFixLine", "^Cursor$", "^lCursor$", "TermCursor", "Thumb",
}

-- Static chrome that sits in the same place all session is the worst burn-in
-- risk, so it goes black however light the colorscheme made it (gruvbox's and
-- everforest's statuslines are mid-greys above DARK).
local ALWAYS = {
  Normal = true, NormalNC = true, NormalFloat = true, NormalSB = true, MsgArea = true,
  StatusLine = true, StatusLineNC = true, TabLine = true, TabLineFill = true,
  WinBar = true, WinBarNC = true, WinSeparator = true, VertSplit = true,
  SignColumn = true, LineNr = true, CursorLineNr = true, FoldColumn = true, EndOfBuffer = true,
}

local function luminance(rgb)
  local function ch(v)
    v = v / 255
    return v <= 0.04045 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4
  end
  local r, g, b = math.floor(rgb / 65536) % 256, math.floor(rgb / 256) % 256, rgb % 256
  return 0.2126 * ch(r) + 0.7152 * ch(g) + 0.0722 * ch(b)
end

local function keep(name)
  for _, pat in ipairs(KEEP) do
    if name:find(pat) then return true end
  end
  return false
end

local function oled_highlights()
  if vim.o.background ~= "dark" then return {} end

  local out = {}
  for name, spec in pairs(vim.api.nvim_get_hl(0, {})) do
    if not spec.link and spec.bg and spec.bg ~= 0 and (ALWAYS[name] or (not keep(name) and luminance(spec.bg) < DARK)) then
      local new = vim.deepcopy(spec)
      new.bg = 0x000000
      out[name] = new
    end
  end

  -- The cursor line goes black like everything else, leaving its number to
  -- mark it. The file tree shows its selection with that line alone, so it
  -- keeps the colour.
  local cursorline = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
  local neotree = vim.api.nvim_get_hl(0, { name = "NeoTreeCursorLine" })
  if cursorline.bg and (vim.tbl_isempty(neotree) or neotree.link) then
    out.NeoTreeCursorLine = { bg = cursorline.bg }
  end

  return out
end

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@param opts AstroUIOpts
  opts = function(_, opts)
    opts.highlights = opts.highlights or {}
    local user_init = opts.highlights.init
    opts.highlights.init = function(colors_name)
      local hl = oled_highlights()
      local extra = type(user_init) == "function" and user_init(colors_name) or user_init
      return vim.tbl_extend("force", hl, extra or {})
    end
  end,
}
