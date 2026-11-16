-- Apariencia: barra de estado (lualine), dashboard (alpha) e íconos.
-- El colorscheme NO es un plugin: es colors/molli-neon.lua (sustituye a gruvbox.nvim).

---Componente de lualine: servidores LSP activos en el buffer (sin null-ls).
local function lsp_clients()
  local names = {}
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name ~= "null-ls" then
      table.insert(names, client.name)
    end
  end
  if #names == 0 then
    return ""
  end
  return "\u{f085} " .. table.concat(names, " · ")
end

local function setup_lualine()
  require("lualine").setup({
    options = {
      theme = require("config.theme.lualine").build(),
      globalstatus = true,
      section_separators = "", -- sin separadores, igual que tu config original
      component_separators = "",
      disabled_filetypes = { statusline = { "alpha" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = {
        { "filename", path = 1, symbols = { modified = " ●", readonly = " \u{f023}", unnamed = "[sin nombre]" } },
        { "diagnostics", sources = { "nvim_diagnostic" } },
      },
      lualine_x = { lsp_clients, "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  })
end

return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = { default = true },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      setup_lualine()
      -- Al recargar el tema (:colorscheme molli-neon) se reconstruye la barra con la paleta nueva.
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("molli_lualine_theme", { clear = true }),
        pattern = "molli-neon",
        callback = setup_lualine,
      })
    end,
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local gradient = require("config.colors").dashboard_gradient

      -- Arte original conservado; cada franja de líneas recibe un color del degradado.
      local header = require("config.ascii")
      local header_hl = {}
      for i = 1, #header do
        local step = math.min(#gradient, math.floor((i - 1) * #gradient / #header) + 1)
        header_hl[i] = { { "AlphaHeader" .. step, 0, -1 } }
      end
      dashboard.section.header.val = header
      dashboard.section.header.opts.hl = header_hl

      -- Los botones apuntan a los atajos reales de esta config (los botones por
      -- defecto de Alpha anunciaban atajos como SPC f h que no existían).
      local function button(shortcut, text, command)
        local b = dashboard.button(shortcut, text, command)
        b.opts.hl = "AlphaButtons"
        b.opts.hl_shortcut = "AlphaShortcut"
        return b
      end
      dashboard.section.buttons.val = {
        button("n", "\u{f15b}  Nuevo archivo", "<cmd>ene<CR>"),
        button("f", "󰈞  Buscar archivo", "<cmd>Telescope find_files<CR>"),
        button("r", "\u{f017}  Archivos recientes", "<cmd>Telescope oldfiles<CR>"),
        button("w", "󰊄  Buscar texto", "<cmd>Telescope live_grep<CR>"),
        button("e", "\u{f07c}  Explorador", "<cmd>Neotree toggle<CR>"),
        button("c", "\u{f013}  Configuración", "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>"),
        button("l", "󰒲  Plugins (Lazy)", "<cmd>Lazy<CR>"),
        button("m", "\u{f487}  Mason", "<cmd>Mason<CR>"),
        button("q", "\u{f011}  Salir", "<cmd>qa<CR>"),
      }

      dashboard.section.footer.opts.hl = "AlphaFooter"
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
          dashboard.section.footer.val = string.format(
            "⚡ %d/%d plugins en %.2f ms  ·  Neovim %s",
            stats.loaded,
            stats.count,
            ms,
            tostring(vim.version())
          )
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      alpha.setup(dashboard.opts)
    end,
  },
}
