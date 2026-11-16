-- Neo-tree: explorador de archivos.
-- Se conserva tu preferencia original `position = "current"`: el árbol se abre
-- en la ventana actual (estilo netrw) en lugar de una barra lateral.
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false, -- neo-tree se carga de forma diferida por sí mismo y así puede abrir directorios (`nvim .`)
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorador de archivos (Neo-tree)" },
      { "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Mostrar archivo actual en Neo-tree" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = { with_expanders = true }, -- de tu config original
      },
      window = {
        position = "current", -- de tu config original
        mappings = {
          ["<space>"] = "none", -- deja libre el leader dentro del árbol
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = { ".DS_Store", "thumbs.db" },
        },
      },
    },
  },
}
