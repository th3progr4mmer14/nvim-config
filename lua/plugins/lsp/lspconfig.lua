-- nvim-lspconfig aporta las configuraciones base de cada servidor (lsp/<nombre>.lua);
-- la activación se hace con vim.lsp.enable() en lua/config/lsp/init.lua.
-- mason-lspconfig sólo instala los servidores (automatic_enable = false para que
-- la lista de servidores activos sea explícita y también incluya los que no
-- vienen de Mason, como rust-analyzer o dartls).
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp", -- sus capacidades se anuncian a los servidores
    },
    config = function()
      require("config.lsp").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      local servers = require("config.lsp.servers")
      local installable, skipped = servers.mason_servers()
      require("mason-lspconfig").setup({
        ensure_installed = vim.g.mason_auto_install and installable or {},
        automatic_enable = false,
      })

      if vim.g.mason_auto_install and next(skipped) then
        local lines = {}
        for name, missing in pairs(skipped) do
          table.insert(lines, string.format("%s (falta %s)", name, table.concat(missing, ", ")))
        end
        table.sort(lines)
        vim.schedule(function()
          vim.notify(
            "Servidores LSP omitidos por requisitos faltantes:\n  " .. table.concat(lines, "\n  "),
            vim.log.levels.WARN,
            { title = "Mason" }
          )
        end)
      end
    end,
  },
}
