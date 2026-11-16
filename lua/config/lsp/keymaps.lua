-- Atajos LSP: se crean SOLO en buffers con un servidor adjunto (LspAttach),
-- así no ocupan teclas en buffers sin LSP.
local M = {}

-- Neovim 0.11+ define por defecto grr, gra, grn, gri, grt, grx. Al mapear `gr`
-- a referencias, esos atajos harían que `gr` esperara 'timeoutlen' antes de
-- ejecutarse. Se eliminan y se ofrecen equivalentes explícitos más abajo.
local function remove_default_gr_maps()
  for _, lhs in ipairs({ "grr", "gra", "grn", "gri", "grt", "grx" }) do
    pcall(vim.keymap.del, "n", lhs)
  end
  pcall(vim.keymap.del, "x", "gra")
end

---@param bufnr integer
local function set_buffer_keymaps(bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = "LSP: " .. desc })
  end

  local telescope = function(picker)
    return function()
      require("telescope.builtin")[picker]()
    end
  end

  map("n", "gd", vim.lsp.buf.definition, "Ir a definición")
  map("n", "gD", vim.lsp.buf.declaration, "Ir a declaración")
  map("n", "gr", telescope("lsp_references"), "Buscar referencias")
  map("n", "gI", telescope("lsp_implementations"), "Ir a implementación")
  map("n", "gy", telescope("lsp_type_definitions"), "Ir a definición de tipo")
  map("n", "K", vim.lsp.buf.hover, "Documentación del símbolo")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Renombrar símbolo")
  map("n", "<leader>ls", telescope("lsp_document_symbols"), "Símbolos del documento")
  map("n", "<leader>lS", telescope("lsp_dynamic_workspace_symbols"), "Símbolos del workspace")
  map("n", "<leader>li", "<cmd>checkhealth vim.lsp<CR>", "Info de servidores activos")
  map("n", "<leader>lr", "<cmd>lsp restart<CR>", "Reiniciar servidores LSP")
end

function M.setup()
  remove_default_gr_maps()

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("molli_lsp_attach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end
      set_buffer_keymaps(args.buf)

      -- Resalta las otras apariciones del símbolo bajo el cursor.
      if client:supports_method("textDocument/documentHighlight", args.buf) then
        local group = vim.api.nvim_create_augroup("molli_lsp_highlight_" .. args.buf, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = group,
          buffer = args.buf,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
          group = group,
          buffer = args.buf,
          callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd("LspDetach", {
          group = group,
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.clear_references()
            pcall(vim.api.nvim_del_augroup_by_id, group)
          end,
        })
      end
    end,
  })
end

return M
