-- Opciones del editor. Se conservan todas las preferencias de la config original.
local opt = vim.opt

-- Indentación: 2 espacios como base (cada ftplugin/formateador puede ajustarlo).
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split" -- vista previa de :s/// en una ventana

-- Navegación y ventanas
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true

-- Interfaz
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.showmode = false -- lualine ya muestra el modo
opt.laststatus = 3 -- una sola barra de estado global
opt.pumheight = 12
opt.winborder = "rounded" -- borde por defecto de ventanas flotantes (Neovim 0.11+)
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.confirm = true -- pregunta en lugar de fallar al salir con cambios

-- Undo persistente.
-- Nota: la config original usaba `vim.bo.undofile = true`, que sólo afecta al
-- primer buffer. `vim.opt.undofile` lo activa para todos los buffers.
opt.undofile = true
opt.swapfile = false

-- Rendimiento / respuesta
opt.updatetime = 250
opt.timeoutlen = 500

-- Plegado con Treesitter (se activa por buffer en plugins/treesitter.lua).
-- foldlevel alto = todo abierto al entrar a un archivo.
opt.foldlevel = 99
opt.foldlevelstart = 99

-- Completado nativo: blink.cmp se encarga del menú; esto evita que el menú
-- nativo interfiera.
opt.completeopt = { "menu", "menuone", "noselect" }

-- Portapapeles del sistema. Se programa con vim.schedule para no retrasar el
-- arranque (la detección del proveedor puede tardar). En Fedora con Wayland
-- requiere `wl-clipboard`; en macOS funciona con pbcopy/pbpaste integrados.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
