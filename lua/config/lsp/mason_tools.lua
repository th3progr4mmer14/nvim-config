-- Instalador de herramientas de Mason que NO son servidores LSP
-- (formateadores y tree-sitter-cli). mason-lspconfig sólo instala LSPs, así que
-- esto cubre el resto sin añadir otro plugin.
local M = {}

local function notify(msg, level)
  vim.schedule(function()
    vim.notify(msg, level or vim.log.levels.INFO, { title = "Mason" })
  end)
end

---Instala las herramientas faltantes de config.lsp.servers.tools.
function M.ensure_installed()
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    return
  end
  local servers = require("config.lsp.servers")

  registry.refresh(function(success)
    if not success then
      notify("No se pudo actualizar el registro de Mason (¿sin conexión?)", vim.log.levels.WARN)
      return
    end

    local skipped = {}
    for _, tool in ipairs(servers.tools) do
      local met, missing = servers.requirements_met(tool.requires)
      if not met then
        table.insert(skipped, string.format("%s (falta %s)", tool.name, table.concat(missing, ", ")))
      elseif registry.has_package(tool.name) then
        local pkg = registry.get_package(tool.name)
        if not pkg:is_installed() and not pkg:is_installing() then
          notify("Instalando " .. tool.name .. "…")
          pkg:install({}, function(installed)
            if installed then
              notify(tool.name .. " instalado")
              vim.schedule(function()
                vim.api.nvim_exec_autocmds("User", { pattern = "MolliMasonToolInstalled", data = { name = tool.name } })
              end)
            else
              notify("Falló la instalación de " .. tool.name .. " (revisa :Mason)", vim.log.levels.ERROR)
            end
          end)
        end
      else
        table.insert(skipped, tool.name .. " (no existe en el registro)")
      end
    end

    if #skipped > 0 then
      notify("Herramientas omitidas:\n  " .. table.concat(skipped, "\n  "), vim.log.levels.WARN)
    end
  end)
end

return M
