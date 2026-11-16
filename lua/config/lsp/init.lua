-- Configuración LSP con la API nativa de Neovim 0.11+/0.12:
--   vim.lsp.config(nombre, opts)  → ajusta la config que trae nvim-lspconfig (lsp/<nombre>.lua)
--   vim.lsp.enable(nombre)        → la activa para los filetypes correspondientes
-- No se usa el patrón obsoleto require("lspconfig").servidor.setup().
local M = {}

local function setup_diagnostics()
  local icons = vim.g.have_nerd_font and { ERROR = "󰅚 ", WARN = "󰀪 ", INFO = "󰋽 ", HINT = "󰌶 " }
    or { ERROR = "E ", WARN = "W ", INFO = "I ", HINT = "H " }
  local severity = vim.diagnostic.severity

  vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
    float = { border = "rounded", source = "if_many", header = "", prefix = "" },
    signs = {
      text = {
        [severity.ERROR] = icons.ERROR,
        [severity.WARN] = icons.WARN,
        [severity.INFO] = icons.INFO,
        [severity.HINT] = icons.HINT,
      },
    },
  })
end

function M.setup()
  setup_diagnostics()
  require("config.lsp.keymaps").setup()

  local format = require("config.lsp.format")
  format.setup_format_on_save()
  vim.keymap.set("n", "<leader>f", format.format, { desc = "Formatear archivo" })
  -- Igual que <leader>f, pero sin la espera de 'timeoutlen' que provoca el prefijo <leader>f{f,w,m}.
  vim.keymap.set("n", "<leader>cf", format.format, { desc = "Formatear archivo (sin espera)" })

  -- Capacidades comunes para todos los servidores (blink.cmp).
  vim.lsp.config("*", { capabilities = require("config.lsp.capabilities").get() })

  local servers = require("config.lsp.servers").servers
  local to_enable = {}
  for name, spec in pairs(servers) do
    if spec.config then
      local cfg = type(spec.config) == "function" and spec.config() or spec.config
      vim.lsp.config(name, cfg)
    end
    local skip = spec.skip_if and vim.fn.executable(spec.skip_if) == 1
    local missing_exe = spec.executable and vim.fn.executable(spec.executable) == 0
    if not skip and not missing_exe then
      table.insert(to_enable, name)
    end
  end
  table.sort(to_enable)

  -- Si el ejecutable de un servidor no existe, Neovim no lo arranca y lo
  -- registra en :checkhealth vim.lsp (no lanza errores al abrir archivos).
  -- Los servidores instalados con Mason durante la sesión se activan al reiniciar
  -- Neovim cuando su `cmd` es una función (jdtls, eslint).
  vim.lsp.enable(to_enable)
end

return M
