-- none-ls: expone formateadores de línea de comandos como si fueran un LSP.
--
-- Reparto de responsabilidades (sin duplicados):
--   · Formateo  → none-ls para los lenguajes listados abajo; el resto usa su LSP
--                 (rust-analyzer→rustfmt, jdtls, dartls). Ver lua/config/lsp/format.lua.
--   · Diagnósticos/lint → los servidores LSP (basedpyright, clangd, gopls,
--                 eslint, etc.). none-ls no añade linters para no repetirlos.
--
-- Cambio respecto a la config original: ESLint pasó de `eslint_d` (none-ls-extras)
-- al servidor `eslint` (vscode-eslint-language-server). Da los mismos
-- diagnósticos más code actions de "fix", no necesita un daemon aparte y sólo se
-- activa en proyectos con configuración de ESLint. Por eso none-ls-extras ya no
-- es necesario.
return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "mason-org/mason.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local fmt = null_ls.builtins.formatting

      null_ls.setup({
        border = "rounded",
        sources = {
          -- Lua: si el proyecto no tiene config de StyLua, usar 2 espacios (preferencia
          -- de esta config) en lugar de tabuladores, que es el default de StyLua.
          fmt.stylua.with({
            extra_args = function(params)
              local found = vim.fs.find({ ".stylua.toml", "stylua.toml", ".editorconfig" }, {
                upward = true,
                path = vim.fs.dirname(params.bufname),
              })
              if #found > 0 then
                return {}
              end
              return { "--indent-type", "Spaces", "--indent-width", "2" }
            end,
          }),
          -- JS / TS / JSON / YAML / CSS / HTML / Markdown
          -- (usa el prettier del proyecto en node_modules si existe)
          fmt.prettier,
          -- Python: isort primero, luego black (perfil compatible)
          fmt.isort.with({ extra_args = { "--profile", "black" } }),
          fmt.black,
          -- C / C++ (el builtin también incluye java; se excluye para que formatee jdtls)
          fmt.clang_format.with({ filetypes = { "c", "cpp", "cuda", "proto" } }),
          -- PHP
          fmt.phpcsfixer,
          -- Go: imports + formato estricto
          fmt.goimports,
          fmt.gofumpt,
          -- SQL con dialecto PostgreSQL
          fmt.sql_formatter.with({ extra_args = { "--language", "postgresql" } }),
        },
      })
    end,
  },
}
