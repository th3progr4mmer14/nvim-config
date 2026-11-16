-- Capacidades que el cliente LSP anuncia a los servidores.
-- blink.cmp añade soporte de snippets, resolución de documentación, etc.
local M = {}

---@param extra? table capacidades adicionales a fusionar
---@return lsp.ClientCapabilities
function M.get(extra)
  local ok, blink = pcall(require, "blink.cmp")
  local base = ok and blink.get_lsp_capabilities(nil, true) or vim.lsp.protocol.make_client_capabilities()

  -- Plegado por LSP disponible para quien lo quiera usar (Neovim 0.11+).
  base.textDocument = base.textDocument or {}
  base.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

  if extra then
    base = vim.tbl_deep_extend("force", base, extra) --[[@as lsp.ClientCapabilities]]
  end
  return base
end

return M
