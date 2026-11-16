-- Variables globales y flags que deben existir ANTES de cargar los plugins.
-- Los flags con vim.F.if_nil respetan un valor previo, p. ej.:
--   nvim --cmd "let g:mason_auto_install = v:false"

-- Leader en espacio. Debe definirse antes de lazy.nvim para que los
-- atajos declarados en las specs de plugins usen el leader correcto.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Neo-tree sustituye a netrw (recomendado por neo-tree para evitar que ambos
-- intenten abrir directorios). `gx` sigue funcionando: desde Neovim 0.10 usa
-- vim.ui.open() y ya no depende de netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Pon esto en false si tu terminal NO usa una Nerd Font (los íconos se verían como cuadros).
vim.g.have_nerd_font = vim.F.if_nil(vim.g.have_nerd_font, true)

-- Instalación automática de servidores LSP y herramientas con Mason al iniciar.
-- Sólo se instalan los paquetes cuyos requisitos (npm, python3, go, php, java) existan.
vim.g.mason_auto_install = vim.F.if_nil(vim.g.mason_auto_install, true)

-- Formatear al guardar. Desactivado por defecto (tu config original formateaba
-- manualmente). Se alterna en caliente con <leader>tf.
vim.g.format_on_save = vim.F.if_nil(vim.g.format_on_save, false)
