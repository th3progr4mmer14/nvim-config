-- Grupos de la interfaz del editor: fondo, cursor, números, menús, diagnósticos.
local M = {}

function M.groups(c)
  local r, b, blend = c.roles, c.brand, c.blend

  return {
    -- Base
    Normal = { fg = r.fg, bg = r.bg },
    NormalNC = { fg = r.fg, bg = r.bg },
    NormalFloat = { fg = r.fg, bg = r.bg_float },
    FloatBorder = { fg = r.border, bg = r.bg_float },
    FloatTitle = { fg = r.match, bg = r.bg_float, bold = true },
    FloatFooter = { fg = r.fg_dim, bg = r.bg_float },
    WinSeparator = { fg = r.separator, bg = r.bg },
    VertSplit = { link = "WinSeparator" },
    EndOfBuffer = { fg = r.bg },
    NonText = { fg = r.line_nr },
    Whitespace = { fg = blend(r.line_nr, r.bg, 0.6) },
    SpecialKey = { fg = r.line_nr },
    Conceal = { fg = r.fg_dim },
    Title = { fg = r.match, bold = true },
    Directory = { fg = b.turquoise },

    -- Cursor y líneas
    Cursor = { fg = r.bg, bg = r.cursor },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { fg = r.bg, bg = r.cursor },
    CursorLine = { bg = r.cursorline },
    CursorColumn = { bg = r.cursorline },
    ColorColumn = { bg = r.cursorline },
    LineNr = { fg = r.line_nr },
    LineNrAbove = { fg = r.line_nr },
    LineNrBelow = { fg = r.line_nr },
    CursorLineNr = { fg = r.line_nr_active, bold = true },
    SignColumn = { fg = r.line_nr, bg = r.bg },
    CursorLineSign = { bg = r.cursorline },
    FoldColumn = { fg = r.line_nr, bg = r.bg },
    CursorLineFold = { fg = r.fg_dim, bg = r.cursorline },
    Folded = { fg = r.fg_dim, bg = blend(b.forest, r.bg, 0.12), italic = true },

    -- Selección y búsqueda
    Visual = { bg = r.selection },
    VisualNOS = { bg = r.selection },
    Search = { fg = r.fg_bright, bg = r.search },
    IncSearch = { fg = r.bg, bg = r.search_current, bold = true },
    CurSearch = { link = "IncSearch" },
    Substitute = { fg = r.bg, bg = r.warn, bold = true },
    MatchParen = { fg = r.cursor, bg = c.base.surface_alt, bold = true },
    QuickFixLine = { bg = r.menu_selection, bold = true },

    -- Menús (popup nativo; Blink tiene sus propios grupos en plugins.lua)
    Pmenu = { fg = r.fg, bg = r.bg_float },
    PmenuSel = { fg = r.fg_bright, bg = r.menu_selection, bold = true },
    PmenuKind = { fg = b.turquoise, bg = r.bg_float },
    PmenuKindSel = { fg = b.turquoise, bg = r.menu_selection, bold = true },
    PmenuExtra = { fg = r.comment, bg = r.bg_float },
    PmenuExtraSel = { fg = r.fg_dim, bg = r.menu_selection },
    PmenuSbar = { bg = r.bg_float },
    PmenuThumb = { bg = r.border },
    PmenuMatch = { fg = r.match, bold = true },
    PmenuMatchSel = { fg = r.match, bg = r.menu_selection, bold = true },
    WildMenu = { link = "PmenuSel" },

    -- Barra de estado / pestañas (lualine las cubre; esto es el fallback)
    StatusLine = { fg = r.fg_dim, bg = r.bg_deep },
    StatusLineNC = { fg = r.line_nr, bg = r.bg_deep },
    TabLine = { fg = r.fg_dim, bg = r.bg_deep },
    TabLineFill = { bg = r.bg_deep },
    TabLineSel = { fg = r.bg, bg = r.mode_normal, bold = true },
    WinBar = { fg = r.fg_dim, bg = r.bg },
    WinBarNC = { fg = r.line_nr, bg = r.bg },

    -- Mensajes
    ModeMsg = { fg = r.match, bold = true },
    MoreMsg = { fg = r.ok, bold = true },
    Question = { fg = b.turquoise },
    ErrorMsg = { fg = r.error, bold = true },
    WarningMsg = { fg = r.warn, bold = true },
    MsgArea = { fg = r.fg },
    MsgSeparator = { fg = r.border, bg = r.bg_deep },

    -- Ortografía
    SpellBad = { undercurl = true, sp = r.error },
    SpellCap = { undercurl = true, sp = r.warn },
    SpellLocal = { undercurl = true, sp = r.info },
    SpellRare = { undercurl = true, sp = r.hint },

    -- Diff
    DiffAdd = { bg = blend(r.added, r.bg, 0.22) },
    DiffChange = { bg = blend(r.changed, r.bg, 0.10) },
    DiffDelete = { fg = blend(r.removed, r.bg, 0.6), bg = blend(r.removed, r.bg, 0.15) },
    DiffText = { bg = blend(r.changed, r.bg, 0.25), bold = true },
    Added = { fg = r.added },
    Changed = { fg = r.changed },
    Removed = { fg = r.removed },
    diffAdded = { fg = r.added },
    diffRemoved = { fg = r.removed },
    diffChanged = { fg = r.changed },

    -- Diagnósticos: color claro + fondo tintado sutil en el texto virtual.
    DiagnosticError = { fg = r.error },
    DiagnosticWarn = { fg = r.warn },
    DiagnosticInfo = { fg = r.info },
    DiagnosticHint = { fg = r.hint },
    DiagnosticOk = { fg = r.ok },
    DiagnosticVirtualTextError = { fg = r.error, bg = blend(r.error, r.bg, 0.10) },
    DiagnosticVirtualTextWarn = { fg = r.warn, bg = blend(r.warn, r.bg, 0.10) },
    DiagnosticVirtualTextInfo = { fg = r.info, bg = blend(r.info, r.bg, 0.08) },
    DiagnosticVirtualTextHint = { fg = r.hint, bg = blend(r.hint, r.bg, 0.08) },
    DiagnosticVirtualTextOk = { fg = r.ok, bg = blend(r.ok, r.bg, 0.10) },
    DiagnosticUnderlineError = { undercurl = true, sp = r.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = r.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = r.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = r.hint },
    DiagnosticUnderlineOk = { undercurl = true, sp = r.ok },
    DiagnosticSignError = { fg = r.error },
    DiagnosticSignWarn = { fg = r.warn },
    DiagnosticSignInfo = { fg = r.info },
    DiagnosticSignHint = { fg = r.hint },
    DiagnosticFloatingError = { fg = r.error, bg = r.bg_float },
    DiagnosticFloatingWarn = { fg = r.warn, bg = r.bg_float },
    DiagnosticFloatingInfo = { fg = r.info, bg = r.bg_float },
    DiagnosticFloatingHint = { fg = r.hint, bg = r.bg_float },
    DiagnosticUnnecessary = { fg = r.comment, italic = true },
    DiagnosticDeprecated = { strikethrough = true, sp = r.fg_dim },

    -- LSP
    LspReferenceText = { bg = c.base.surface_alt },
    LspReferenceRead = { bg = c.base.surface_alt },
    LspReferenceWrite = { bg = c.base.surface_alt, underline = true, sp = r.match },
    LspReferenceTarget = { bg = c.base.surface_alt },
    LspSignatureActiveParameter = { fg = r.cursor, bold = true, underline = true },
    LspCodeLens = { fg = r.comment, italic = true },
    LspCodeLensSeparator = { fg = r.line_nr },
    LspInlayHint = { fg = r.comment, bg = blend(b.forest, r.bg, 0.08), italic = true },
    LspInfoBorder = { link = "FloatBorder" },

    -- Health (:checkhealth)
    healthError = { fg = r.error },
    healthSuccess = { fg = r.ok },
    healthWarning = { fg = r.warn },
  }
end

return M
