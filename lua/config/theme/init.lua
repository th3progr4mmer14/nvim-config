-- Motor del tema: limpia los grupos existentes y aplica los de cada módulo.
local M = {}

M.name = "molli-neon"

---Aplica una tabla { Grupo = { fg=..., bg=..., ... } } con nvim_set_hl.
---@param groups table<string, vim.api.keyset.highlight>
local function apply(groups)
  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

local function set_terminal_colors(c)
  local b, r = c.brand, c.roles
  local term = {
    c.base.bg_deep, -- 0 negro
    r.error, -- 1 rojo
    b.emerald, -- 2 verde
    r.warn, -- 3 amarillo
    b.turquoise, -- 4 azul (el tema no usa azul puro)
    c.blend(b.neon_mint, r.error, 0.35), -- 5 magenta suavizado
    b.cyan, -- 6 cian
    r.fg_dim, -- 7 blanco
    r.line_nr, -- 8 negro brillante
    c.blend(r.error, r.fg_bright, 0.8), -- 9
    b.neon_mint, -- 10
    c.blend(r.warn, r.fg_bright, 0.8), -- 11
    c.blend(b.turquoise, r.fg_bright, 0.8), -- 12
    c.blend(b.neon_mint, r.error, 0.55), -- 13
    c.blend(b.cyan, r.fg_bright, 0.8), -- 14
    r.fg_bright, -- 15
  }
  for i, color in ipairs(term) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  vim.o.background = "dark"
  vim.o.termguicolors = true
  vim.g.colors_name = M.name

  local c = require("config.colors")
  apply(require("config.theme.editor").groups(c))
  apply(require("config.theme.syntax").groups(c))
  apply(require("config.theme.plugins").groups(c))
  set_terminal_colors(c)
end

return M
