-- Formateo unificado: un solo comando decide QUIÉN formatea cada archivo,
-- para que nunca formateen dos herramientas a la vez.
--
-- Regla:
--   1. Si none-ls tiene un formateador registrado para el filetype → sólo none-ls
--      (StyLua, Prettier, Black+isort, clang-format, php-cs-fixer, gofumpt+goimports, sql-formatter).
--   2. Si no → el servidor LSP del buffer (rust-analyzer→rustfmt, jdtls, dartls).
local M = {}

---@param bufnr integer
---@return boolean
local function none_ls_formats(bufnr)
  local ok_sources, sources = pcall(require, "null-ls.sources")
  local ok_nls, null_ls = pcall(require, "null-ls")
  if not (ok_sources and ok_nls) then
    return false
  end
  local ft = vim.bo[bufnr].filetype
  return #sources.get_available(ft, null_ls.methods.FORMATTING) > 0
end

---Formatea el buffer actual (o `bufnr`).
---@param opts? { bufnr?: integer, async?: boolean }
function M.format(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local use_none_ls = none_ls_formats(bufnr)

  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/formatting" })
  if #clients == 0 then
    vim.notify("Ningún formateador disponible para este archivo", vim.log.levels.WARN, { title = "Formato" })
    return
  end

  vim.lsp.buf.format({
    bufnr = bufnr,
    async = opts.async or false,
    timeout_ms = 3000,
    filter = function(client)
      if use_none_ls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  })
end

---Autocomando de formateo al guardar (controlado por vim.g.format_on_save).
function M.setup_format_on_save()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("molli_format_on_save", { clear = true }),
    callback = function(args)
      if vim.g.format_on_save and vim.b[args.buf].format_on_save ~= false then
        M.format({ bufnr = args.buf })
      end
    end,
  })
end

return M
