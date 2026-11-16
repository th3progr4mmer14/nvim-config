-- Java: jdtls se activa con vim.lsp.enable("jdtls") (ver lua/config/lsp/servers.lua).
-- nvim-jdtls se añade para lo que el LSP genérico no cubre:
--   · abrir clases de dependencias (URIs jdt:// y archivos .class)
--   · refactors propios de jdtls (extraer variable/constante/método, organizar imports)
--   · registro automático del adaptador de depuración `java` en nvim-dap
--     cuando están instalados java-debug-adapter y java-test (ver README → Depuración)
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
}
