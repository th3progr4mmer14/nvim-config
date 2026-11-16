-- Autocomandos generales. Cada grupo se limpia al recargar (clear = true)
-- para no duplicar autocomandos.
local function augroup(name)
  return vim.api.nvim_create_augroup("molli_" .. name, { clear = true })
end

-- Resaltar brevemente el texto copiado.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 180 })
  end,
})

-- Volver a la última posición del cursor al reabrir un archivo.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  callback = function(args)
    local ignore = { gitcommit = true, gitrebase = true }
    if ignore[vim.bo[args.buf].filetype] or vim.b[args.buf].molli_last_pos then
      return
    end
    vim.b[args.buf].molli_last_pos = true
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Igualar el tamaño de las ventanas cuando cambia el tamaño de la terminal.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current)
  end,
})

-- Cerrar ventanas auxiliares con `q`.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "lspinfo", "checkhealth", "man", "dap-float", "notify" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true, desc = "Cerrar ventana" })
  end,
})

-- Crear los directorios intermedios al guardar un archivo nuevo.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(args)
    if args.match:match("^%w%w+:[\\/][\\/]") then
      return -- URLs como oil://, jdt://, etc.
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Aviso único si el portapapeles del sistema no tiene proveedor (p. ej. falta wl-clipboard en Fedora).
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("clipboard_check"),
  once = true,
  callback = function()
    vim.defer_fn(function()
      -- has("clipboard") vale 1 sólo si Neovim encontró un proveedor que funciona.
      if vim.fn.has("clipboard") == 0 and not vim.env.SSH_TTY and #vim.api.nvim_list_uis() > 0 then
        local _, hint = require("config.platform").clipboard_provider()
        vim.notify(
          "Portapapeles del sistema no disponible. Sugerencia: " .. hint,
          vim.log.levels.WARN,
          { title = "nvim-config" }
        )
      end
    end, 500)
  end,
})
