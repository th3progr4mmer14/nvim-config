-- ╭──────────────────────────────────────────────────────────────╮
-- │  nvim-config · Molli                                         │
-- │  Punto de entrada. El orden importa:                         │
-- │    1. globals  → leader y flags antes de cargar plugins      │
-- │    2. options  → opciones del editor                         │
-- │    3. lazy     → bootstrap de lazy.nvim y carga de plugins   │
-- │    4. tema     → colorscheme propio (colors/molli-neon.lua)  │
-- │    5. keymaps / autocmds generales                           │
-- ╰──────────────────────────────────────────────────────────────╯

if vim.fn.has("nvim-0.12") == 0 then
  vim.api.nvim_echo({
    { "nvim-config requiere Neovim 0.12 o superior (detectado: ", "ErrorMsg" },
    { tostring(vim.version()), "WarningMsg" },
    { ")", "ErrorMsg" },
  }, true, {})
  return
end

require("config.globals")
require("config.options")
require("config.lazy")

-- El tema no es un plugin: vive en colors/ y lee la paleta de lua/config/colors.lua.
local ok_theme, theme_err = pcall(vim.cmd.colorscheme, "molli-neon")
if not ok_theme then
  vim.notify("No se pudo cargar el tema molli-neon: " .. tostring(theme_err), vim.log.levels.ERROR)
end

require("config.keymaps")
require("config.autocmds")
-- El LSP se configura al cargar nvim-lspconfig (lua/plugins/lsp/lspconfig.lua).

-- Ajustes personales por máquina (no versionados, ver .gitignore).
local local_config = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "config", "local.lua")
if vim.uv.fs_stat(local_config) then
  require("config.local")
end
