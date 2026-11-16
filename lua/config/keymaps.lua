-- Atajos generales del editor.
-- Los atajos de cada plugin viven en su propia spec (`keys = {...}`) y los del
-- LSP en lua/config/lsp/keymaps.lua (se crean sólo en buffers con LSP).
-- La tabla completa está en el README, sección "Atajos de teclado".
local map = vim.keymap.set

-- Limpiar el resaltado de búsqueda (sustituye al <C-l> nativo, que ahora navega ventanas).
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado de búsqueda" })

-- Navegación entre ventanas con Ctrl+h/j/k/l.
-- Dentro de tmux estos mismos atajos los define nvim-tmux-navigation
-- (lua/plugins/tmuxnav.lua) para cruzar también entre paneles de tmux.
if not vim.env.TMUX then
  map("n", "<C-h>", "<C-w>h", { desc = "Ventana izquierda" })
  map("n", "<C-j>", "<C-w>j", { desc = "Ventana inferior" })
  map("n", "<C-k>", "<C-w>k", { desc = "Ventana superior" })
  map("n", "<C-l>", "<C-w>l", { desc = "Ventana derecha" })
end

-- Redimensionar ventanas con Ctrl+flechas.
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Aumentar altura" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Reducir altura" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Reducir ancho" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Aumentar ancho" })

-- Salir del modo terminal con doble Esc.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Salir del modo terminal" })

-- Mover la selección visual arriba/abajo y mantener la selección.
map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Mover selección abajo", silent = true })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Mover selección arriba", silent = true })

-- Mantener la selección al indentar.
map("x", "<", "<gv", { desc = "Indentar a la izquierda" })
map("x", ">", ">gv", { desc = "Indentar a la derecha" })

-- Buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Buffer siguiente" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })

-- Diagnósticos (funcionan con o sin LSP: none-ls también publica diagnósticos).
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Diagnóstico de la línea" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnósticos a la lista local" })
-- [d / ]d (anterior/siguiente) ya vienen por defecto en Neovim 0.11+.

-- Alternar opciones
map("n", "<leader>tf", function()
  vim.g.format_on_save = not vim.g.format_on_save
  vim.notify("Formatear al guardar: " .. (vim.g.format_on_save and "activado" or "desactivado"))
end, { desc = "Alternar formateo al guardar" })

map("n", "<leader>tw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Alternar ajuste de línea" })

map("n", "<leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Alternar inlay hints" })
