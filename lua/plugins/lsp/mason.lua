-- Mason: instala servidores LSP, formateadores y depuradores en
-- stdpath("data")/mason (fuera del repositorio) y los añade al PATH de Neovim.
return {
  {
    "mason-org/mason.nvim",
    -- No se carga de forma diferida (recomendación oficial): su setup sólo
    -- añade mason/bin al PATH, y otros plugins (treesitter, LSP) lo necesitan al inicio.
    lazy = false,
    priority = 900,
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" },
    keys = { { "<leader>cm", "<cmd>Mason<CR>", desc = "Abrir Mason" } },
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- Lombok para jdtls (Spring Boot / proyectos con anotaciones). lspconfig lee
      -- JDTLS_JVM_ARGS al construir el comando de jdtls.
      local lombok = vim.fs.joinpath(vim.env.MASON or "", "share", "jdtls", "lombok.jar")
      if not vim.env.JDTLS_JVM_ARGS and vim.uv.fs_stat(lombok) then
        vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. lombok
      end

      if vim.g.mason_auto_install then
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          callback = function()
            vim.defer_fn(require("config.lsp.mason_tools").ensure_installed, 100)
          end,
        })
      end
    end,
  },
}
