-- Colorscheme Molli Neon. `:colorscheme molli-neon` busca este archivo en el runtimepath.
-- Se limpian los módulos del caché para que, si editas lua/config/colors.lua,
-- volver a ejecutar `:colorscheme molli-neon` aplique los cambios sin reiniciar.
for _, mod in ipairs({
  "config.colors",
  "config.theme",
  "config.theme.editor",
  "config.theme.syntax",
  "config.theme.plugins",
  "config.theme.lualine",
}) do
  package.loaded[mod] = nil
end

require("config.theme").load()
