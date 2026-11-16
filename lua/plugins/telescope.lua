-- Telescope: búsqueda difusa de archivos, texto, buffers, símbolos, etc.
-- ripgrep (`rg`) y fd (`fd`) son BINARIOS del sistema, no plugins: la config
-- original declaraba "BurntSushi/ripgrep" como dependencia de lazy, lo que sólo
-- clonaba su código fuente sin instalar nada. Se instalan con dnf/brew (README).
local function builtin(name, opts)
  return function()
    require("telescope.builtin")[name](opts)
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*", -- última versión etiquetada (0.2.x a la fecha)
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- Ordenamiento nativo en C (más rápido). Requiere `make` y un compilador;
        -- si no están, Telescope funciona igual con su ordenamiento en Lua.
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      -- Atajos pedidos
      { "<leader>ff", builtin("find_files"), desc = "Buscar archivos" },
      { "<leader>fw", builtin("live_grep"), desc = "Buscar texto (ripgrep)" },
      { "<leader>fm", builtin("buffers", { sort_mru = true, ignore_current_buffer = true }), desc = "Buscar buffers" },
      -- Extras
      { "<leader>fM", builtin("marks"), desc = "Buscar marcas (antes <leader>fm)" },
      { "<leader>fh", builtin("help_tags"), desc = "Buscar en la ayuda" },
      { "<leader>fr", builtin("oldfiles"), desc = "Archivos recientes" },
      { "<leader>fd", builtin("diagnostics"), desc = "Buscar diagnósticos" },
      { "<leader>fk", builtin("keymaps"), desc = "Buscar atajos" },
      { "<leader>fc", builtin("grep_string"), desc = "Buscar palabra bajo el cursor" },
      { "<leader>f/", builtin("current_buffer_fuzzy_find"), desc = "Buscar en el buffer actual" },
      {
        "<leader>fn",
        builtin("find_files", { cwd = vim.fn.stdpath("config") }),
        desc = "Archivos de la config de Neovim",
      },
      { "<leader>fR", builtin("resume"), desc = "Retomar última búsqueda" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      local find_command
      local fd = require("config.platform").fd_command()
      if fd then
        find_command = { fd, "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git" }
      elseif vim.fn.executable("rg") == 1 then
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
      end

      telescope.setup({
        defaults = {
          prompt_prefix = "\u{f002}  ", -- ícono de lupa (Nerd Font)
          selection_caret = "▍ ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            width = 0.87,
            height = 0.80,
          },
          path_display = { "truncate" },
          file_ignore_patterns = { "%.git/", "node_modules/", "%.dart_tool/", "target/", "build/", "__pycache__/" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = { find_command = find_command },
          live_grep = { additional_args = { "--hidden", "--glob", "!**/.git/*" } },
          buffers = { mappings = { i = { ["<C-d>"] = actions.delete_buffer } } },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
