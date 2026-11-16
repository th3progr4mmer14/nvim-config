-- Grupos de plugins: Telescope, Neo-tree, Blink.cmp, Alpha, Mason, Lazy, nvim-dap.
-- La barra de estado (lualine) construye su tema en lua/config/theme/lualine.lua.
local M = {}

function M.groups(c)
  local r, b, blend = c.roles, c.brand, c.blend
  local groups = {}

  -- ── Telescope ────────────────────────────────────────────────
  local prompt_bg = blend(b.emerald, r.bg_float, 0.10)
  groups.TelescopeNormal = { fg = r.fg, bg = r.bg_float }
  groups.TelescopeBorder = { fg = r.border, bg = r.bg_float }
  groups.TelescopePromptNormal = { fg = r.fg_bright, bg = prompt_bg }
  groups.TelescopePromptBorder = { fg = b.emerald, bg = prompt_bg }
  groups.TelescopePromptTitle = { fg = r.bg, bg = b.emerald, bold = true }
  groups.TelescopePromptPrefix = { fg = r.cursor, bg = prompt_bg }
  groups.TelescopePromptCounter = { fg = r.fg_dim, bg = prompt_bg }
  groups.TelescopeResultsNormal = { fg = r.fg_dim, bg = r.bg_float }
  groups.TelescopeResultsBorder = { fg = r.border, bg = r.bg_float }
  groups.TelescopeResultsTitle = { fg = r.bg, bg = b.forest, bold = true }
  groups.TelescopePreviewNormal = { fg = r.fg, bg = r.bg_float }
  groups.TelescopePreviewBorder = { fg = r.border, bg = r.bg_float }
  groups.TelescopePreviewTitle = { fg = r.bg, bg = b.turquoise, bold = true }
  groups.TelescopeSelection = { fg = r.fg_bright, bg = r.menu_selection, bold = true }
  groups.TelescopeSelectionCaret = { fg = r.cursor, bg = r.menu_selection }
  groups.TelescopeMultiSelection = { fg = r.match, bg = c.base.surface_alt }
  groups.TelescopeMultiIcon = { fg = r.match }
  groups.TelescopeMatching = { fg = r.match, bold = true }
  groups.TelescopeTitle = { fg = r.match, bold = true }

  -- ── Neo-tree ─────────────────────────────────────────────────
  groups.NeoTreeNormal = { fg = r.fg_dim, bg = r.bg_deep }
  groups.NeoTreeNormalNC = { fg = r.fg_dim, bg = r.bg_deep }
  groups.NeoTreeEndOfBuffer = { fg = r.bg_deep, bg = r.bg_deep }
  groups.NeoTreeSignColumn = { bg = r.bg_deep }
  groups.NeoTreeWinSeparator = { fg = r.bg_deep, bg = r.bg_deep }
  groups.NeoTreeCursorLine = { bg = r.menu_selection, bold = true }
  groups.NeoTreeRootName = { fg = r.match, bold = true }
  groups.NeoTreeDirectoryName = { fg = b.turquoise }
  groups.NeoTreeDirectoryIcon = { fg = b.turquoise }
  groups.NeoTreeFileName = { fg = r.fg }
  groups.NeoTreeFileNameOpened = { fg = r.cursor, bold = true }
  groups.NeoTreeFileIcon = { fg = r.fg_dim }
  groups.NeoTreeIndentMarker = { fg = c.base.border }
  groups.NeoTreeExpander = { fg = b.forest }
  groups.NeoTreeDotfile = { fg = r.comment }
  groups.NeoTreeHiddenByName = { fg = r.comment }
  groups.NeoTreeDimText = { fg = r.line_nr }
  groups.NeoTreeFadeText = { fg = r.line_nr }
  groups.NeoTreeModified = { fg = r.warn }
  groups.NeoTreeFilterTerm = { fg = r.match, bold = true }
  groups.NeoTreeTitleBar = { fg = r.bg, bg = b.emerald, bold = true }
  groups.NeoTreeFloatBorder = { fg = r.border, bg = r.bg_float }
  groups.NeoTreeFloatTitle = { fg = r.match, bg = r.bg_float, bold = true }
  groups.NeoTreeTabActive = { fg = r.match, bg = r.bg_deep, bold = true }
  groups.NeoTreeTabInactive = { fg = r.line_nr, bg = r.bg_deep }
  groups.NeoTreeTabSeparatorActive = { fg = r.bg_deep, bg = r.bg_deep }
  groups.NeoTreeTabSeparatorInactive = { fg = r.bg_deep, bg = r.bg_deep }
  groups.NeoTreeGitAdded = { fg = r.added }
  groups.NeoTreeGitModified = { fg = r.changed }
  groups.NeoTreeGitDeleted = { fg = r.removed }
  groups.NeoTreeGitConflict = { fg = r.error, bold = true }
  groups.NeoTreeGitUntracked = { fg = b.neon_mint, italic = true }
  groups.NeoTreeGitIgnored = { fg = r.comment }
  groups.NeoTreeGitStaged = { fg = b.emerald }
  groups.NeoTreeGitUnstaged = { fg = r.warn }
  groups.NeoTreeGitRenamed = { fg = b.turquoise }
  groups.NeoTreeMessage = { fg = r.comment, italic = true }

  -- ── Blink.cmp ────────────────────────────────────────────────
  groups.BlinkCmpMenu = { fg = r.fg, bg = r.bg_float }
  groups.BlinkCmpMenuBorder = { fg = r.border, bg = r.bg_float }
  groups.BlinkCmpMenuSelection = { bg = r.menu_selection, bold = true }
  groups.BlinkCmpLabel = { fg = r.fg }
  groups.BlinkCmpLabelMatch = { fg = r.match, bold = true }
  groups.BlinkCmpLabelDeprecated = { fg = r.comment, strikethrough = true }
  groups.BlinkCmpLabelDetail = { fg = r.comment }
  groups.BlinkCmpLabelDescription = { fg = r.comment }
  groups.BlinkCmpSource = { fg = r.line_nr, italic = true }
  groups.BlinkCmpGhostText = { fg = r.comment, italic = true }
  groups.BlinkCmpDoc = { fg = r.fg, bg = r.bg_float }
  groups.BlinkCmpDocBorder = { fg = r.border, bg = r.bg_float }
  groups.BlinkCmpDocSeparator = { fg = c.base.border, bg = r.bg_float }
  groups.BlinkCmpDocCursorLine = { bg = r.cursorline }
  groups.BlinkCmpSignatureHelp = { fg = r.fg, bg = r.bg_float }
  groups.BlinkCmpSignatureHelpBorder = { fg = r.border, bg = r.bg_float }
  groups.BlinkCmpSignatureHelpActiveParameter = { fg = r.cursor, bold = true, underline = true }
  groups.BlinkCmpScrollBarThumb = { bg = r.border }
  groups.BlinkCmpScrollBarGutter = { bg = r.bg_float }
  groups.BlinkCmpKind = { fg = b.turquoise }

  -- Íconos de tipo (kind) por familia semántica, consistentes con la sintaxis.
  local kind_colors = {
    [b.turquoise] = { "Function", "Method", "Constructor", "Event", "Operator" },
    [b.neon_mint] = { "Class", "Interface", "Struct", "Enum", "TypeParameter", "Module" },
    [b.cyan] = { "Constant", "EnumMember", "Value", "Snippet", "Color" },
    [b.emerald] = { "Keyword", "Reference" },
    [b.forest] = { "File", "Folder", "Unit" },
    [r.property] = { "Field", "Property" },
    [r.fg_dim] = { "Variable", "Text" },
  }
  for color, kinds in pairs(kind_colors) do
    for _, kind in ipairs(kinds) do
      groups["BlinkCmpKind" .. kind] = { fg = color }
    end
  end

  -- ── Alpha (dashboard) ────────────────────────────────────────
  for i, color in ipairs(c.dashboard_gradient) do
    groups["AlphaHeader" .. i] = { fg = color }
  end
  groups.AlphaButtons = { fg = r.fg }
  groups.AlphaShortcut = { fg = r.cursor, bold = true }
  groups.AlphaFooter = { fg = r.comment, italic = true }

  -- ── Lazy / Mason ─────────────────────────────────────────────
  groups.LazyH1 = { fg = r.bg, bg = b.emerald, bold = true }
  groups.LazyButton = { fg = r.fg_dim, bg = c.base.surface }
  groups.LazyButtonActive = { fg = r.bg, bg = b.neon_mint, bold = true }
  groups.LazySpecial = { fg = b.turquoise }
  groups.LazyProgressDone = { fg = b.emerald }
  groups.LazyProgressTodo = { fg = r.line_nr }
  groups.MasonHeader = { fg = r.bg, bg = b.emerald, bold = true }
  groups.MasonHighlight = { fg = b.turquoise }
  groups.MasonHighlightBlock = { fg = r.bg, bg = b.turquoise }
  groups.MasonHighlightBlockBold = { fg = r.bg, bg = b.neon_mint, bold = true }
  groups.MasonMuted = { fg = r.comment }
  groups.MasonMutedBlock = { fg = r.fg_dim, bg = c.base.surface }

  -- ── nvim-dap ─────────────────────────────────────────────────
  groups.DapBreakpoint = { fg = r.error }
  groups.DapBreakpointCondition = { fg = r.warn }
  groups.DapLogPoint = { fg = b.turquoise }
  groups.DapStopped = { fg = b.neon_mint }
  groups.DapStoppedLine = { bg = blend(b.neon_mint, r.bg, 0.12) }

  return groups
end

return M
