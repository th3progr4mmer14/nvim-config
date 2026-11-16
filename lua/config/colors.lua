-- ╭──────────────────────────────────────────────────────────────╮
-- │  Paleta Molli Neon — ÚNICA fuente de verdad de los colores    │
-- │                                                              │
-- │  Para cambiar un color edita SOLO este archivo y ejecuta      │
-- │  :colorscheme molli-neon (o reinicia). Tema, lualine,         │
-- │  Telescope, Neo-tree, Blink, Alpha y diagnósticos leen de     │
-- │  aquí.                                                       │
-- ╰──────────────────────────────────────────────────────────────╯

local M = {}

-- 1. Los cinco colores de identidad (HEX exactos, no se modifican).
M.brand = {
  cyan = "#00FFFF", -- Cyan: cursor, selección, números/constantes, detalles críticos
  emerald = "#009966", -- Emerald: palabras clave, modo NORMAL, elementos activos, OK
  forest = "#008F39", -- Forest Green: bordes, delimitadores, acentos secundarios
  turquoise = "#00CEC8", -- Turquoise: funciones, métodos, atributos, interactivos
  neon_mint = "#26F7C1", -- Neon Mint: tipos, foco, coincidencias, info importante
}

-- 2. Tonos derivados: fondos, superficies y texto. Son oscuros/neutros para que
--    los cinco colores de marca funcionen como acentos, nunca como superficies.
M.base = {
  bg_deep = "#050B0B", -- barras laterales (Neo-tree), dashboard, statusline
  bg = "#081111", -- fondo principal: negro con tinte verde-azulado
  bg_float = "#0C1817", -- ventanas flotantes, menús, Telescope
  surface = "#10201F", -- cursorline, elementos elevados
  surface_alt = "#163029", -- selección de menús (sin acento)
  border = "#1C3532", -- separadores de ventana discretos
  line_nr = "#3A5A55", -- números de línea inactivos
  comment = "#62857F", -- comentarios (legibles pero en segundo plano)
  fg_dim = "#93B6B0", -- texto secundario
  fg = "#D3ECE7", -- texto principal (blanco con tinte menta)
  fg_bright = "#F0FFFB", -- texto enfatizado

  -- Acentos funcionales fuera de la marca (sólo donde la semántica lo exige).
  sand = "#DCC48E", -- cadenas de texto: cálido y suave para contrastar con la paleta fría
  error = "#FF5C7A",
  warn = "#F5BE4F",
}

-- 3. Mezcla de colores: permite derivar fondos tintados (selección,
--    diagnósticos, diff) sin inventar más HEX a mano.
local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---Mezcla `fg` sobre `bg` con opacidad `alpha` (0..1).
---@param fg string
---@param bg string
---@param alpha number
---@return string
function M.blend(fg, bg, alpha)
  local fr, fgc, fb = hex_to_rgb(fg)
  local br, bgc, bb = hex_to_rgb(bg)
  local function channel(a, b)
    return math.floor(math.min(math.max(alpha * a + (1 - alpha) * b, 0), 255) + 0.5)
  end
  return string.format("#%02X%02X%02X", channel(fr, br), channel(fgc, bgc), channel(fb, bb))
end

local b, s = M.brand, M.base

-- 4. Roles semánticos. El tema usa SIEMPRE estos nombres, no los HEX.
--    Cambiar un rol aquí cambia todos los lugares donde se usa.
M.roles = {
  -- Editor
  bg = s.bg,
  bg_deep = s.bg_deep,
  bg_float = s.bg_float,
  fg = s.fg,
  fg_dim = s.fg_dim,
  fg_bright = s.fg_bright,
  comment = s.comment,
  line_nr = s.line_nr,
  line_nr_active = b.neon_mint,
  cursor = b.cyan,
  cursorline = s.surface,
  selection = M.blend(b.cyan, s.bg, 0.22),
  search = M.blend(b.emerald, s.bg, 0.45),
  search_current = b.neon_mint,
  border = b.forest,
  separator = s.border,
  menu_selection = M.blend(b.emerald, s.bg_float, 0.40),
  match = b.neon_mint,

  -- Sintaxis
  keyword = b.emerald,
  func = b.turquoise,
  type = b.neon_mint,
  constant = b.cyan,
  string = s.sand,
  escape = b.neon_mint,
  property = M.blend(b.turquoise, s.fg, 0.35),
  parameter = M.blend(b.turquoise, s.fg, 0.15),
  operator = s.fg_dim,
  punctuation = M.blend(b.forest, s.fg_dim, 0.55),
  tag = b.emerald,
  namespace = M.blend(b.neon_mint, s.fg_dim, 0.30),

  -- Estados y diagnósticos
  error = s.error,
  warn = s.warn,
  info = b.neon_mint,
  hint = b.turquoise,
  ok = b.emerald,
  added = b.forest,
  changed = s.warn,
  removed = s.error,

  -- Modos (lualine)
  mode_normal = b.emerald,
  mode_insert = b.cyan,
  mode_visual = b.neon_mint,
  mode_replace = s.error,
  mode_command = b.turquoise,
  mode_terminal = b.forest,
}

-- 5. Degradado del dashboard (Alpha): de arriba hacia abajo.
M.dashboard_gradient = { b.cyan, b.neon_mint, b.turquoise, b.emerald, b.forest }

return M
