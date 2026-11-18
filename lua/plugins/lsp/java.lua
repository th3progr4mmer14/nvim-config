-- Java: jdtls se activa con vim.lsp.enable("jdtls") (ver lua/config/lsp/servers.lua).
-- nvim-jdtls se añade para lo que el LSP genérico no cubre:
--   · abrir clases de dependencias (URIs jdt:// y archivos .class)
--   · refactors propios de jdtls (extraer variable/constante/método, organizar imports)
--   · registro automático del adaptador de depuración `java` en nvim-dap
--     cuando están instalados java-debug-adapter y java-test (ver README → Depuración)
--
-- spring-boot.nvim conecta el servidor oficial de Spring (vscode-spring-boot-tools,
-- instalado por Mason) para:
--   · autocompletado y validación de application.yml / application.properties
--   · beans, endpoints y anotaciones de Spring (:SpringBoot)
--   · extensiones de jdtls para Spring (se añaden en lua/config/lsp/servers.lua)
-- Sólo arranca en proyectos que dependen de Spring Boot.
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    keys = {
      {
        "<leader>jo",
        function()
          require("jdtls").organize_imports()
        end,
        ft = "java",
        desc = "Java: organizar imports",
      },
      {
        "<leader>jv",
        function()
          require("jdtls").extract_variable()
        end,
        ft = "java",
        desc = "Java: extraer variable",
      },
      {
        "<leader>jc",
        function()
          require("jdtls").extract_constant()
        end,
        ft = "java",
        desc = "Java: extraer constante",
      },
      {
        "<leader>jm",
        function()
          require("jdtls").extract_method({ visual = true })
        end,
        mode = "x",
        ft = "java",
        desc = "Java: extraer método",
      },
      {
        "<leader>jt",
        function()
          require("jdtls").test_nearest_method()
        end,
        ft = "java",
        desc = "Java: depurar test cercano",
      },
      {
        "<leader>jT",
        function()
          require("jdtls").test_class()
        end,
        ft = "java",
        desc = "Java: depurar clase de test",
      },
    },
  },
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    dependencies = { "mfussenegger/nvim-jdtls" },
    cond = function()
      return vim.fn.executable("java") == 1
    end,
    keys = {
      { "<leader>jb", "<cmd>SpringBoot Beans<CR>", ft = "java", desc = "Spring: buscar beans" },
      { "<leader>je", "<cmd>SpringBoot RequestMappings<CR>", ft = "java", desc = "Spring: buscar endpoints" },
      { "<leader>ja", "<cmd>SpringBoot Annotations<CR>", ft = "java", desc = "Spring: buscar anotaciones" },
    },
    opts = {
      project_filter = function(root_dir)
        return require("spring_boot.util").has_spring_boot_dependency(root_dir)
      end,
    },
  },
}
