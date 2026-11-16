-- Bootstrap de lazy.nvim y carga de los módulos de plugins.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "No se pudo clonar lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nVerifica tu conexión y que git esté instalado. Presiona una tecla para salir." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lsp" },
  },
  defaults = { lazy = false },
  -- El tema es local (colors/molli-neon.lua); esto sólo aplica a la pantalla de instalación.
  install = { colorscheme = { "molli-neon", "habamax" } },
  checker = { enabled = false }, -- no buscar actualizaciones en segundo plano
  change_detection = { notify = false },
  ui = { border = "rounded" },
  rocks = { enabled = false }, -- ningún plugin de esta config necesita luarocks
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tutor", "zipPlugin", "netrwPlugin" },
    },
  },
})
