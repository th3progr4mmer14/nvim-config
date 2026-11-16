-- ╭──────────────────────────────────────────────────────────────╮
-- │  Servidores LSP y herramientas externas                      │
-- │                                                              │
-- │  servers: nombre de nvim-lspconfig → opciones                 │
-- │    mason    = true  → lo instala Mason (vía mason-lspconfig)  │
-- │    mason    = false → lo instalas tú (rustup, SDK, etc.)      │
-- │    requires = ejecutable que Mason necesita para instalarlo   │
-- │    executable = binario del servidor; sólo hace falta cuando  │
-- │               lspconfig define `cmd` como función (Neovim no  │
-- │               puede comprobarlo solo y mostraría un error)    │
-- │    config   = tabla que se pasa a vim.lsp.config(nombre, ...) │
-- │                                                              │
-- │  tools: paquetes de Mason que NO son LSP (formateadores...)   │
-- ╰──────────────────────────────────────────────────────────────╯
local M = {}

M.servers = {
  -- Lua (la config misma)
  lua_ls = {
    mason = true,
    config = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          },
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          hint = { enable = true },
          format = { enable = false }, -- StyLua (none-ls) formatea Lua
          telemetry = { enable = false },
        },
      },
    },
  },

  -- JavaScript / TypeScript
  ts_ls = { mason = true, requires = "npm" },
  eslint = { mason = true, requires = "npm", executable = "vscode-eslint-language-server" }, -- diagnósticos + code actions de ESLint (sólo en proyectos con config de ESLint)

  -- Web
  html = { mason = true, requires = "npm" },
  cssls = { mason = true, requires = "npm" },
  jsonls = { mason = true, requires = "npm" },
  yamlls = {
    mason = true,
    requires = "npm",
    config = { settings = { yaml = { keyOrdering = false } } },
  },

  -- Python: basedpyright (fork mantenido de pyright con mejoras de tipado).
  -- Sustituye a pyright + jedi_language_server de la config original, que
  -- corrían a la vez y duplicaban diagnósticos y completado.
  basedpyright = {
    mason = true,
    requires = "python3",
    config = {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard", -- "recommended" (default) es muy estricto para el día a día
            autoImportCompletions = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
    },
  },

  -- PHP
  intelephense = { mason = true, requires = "npm" },

  -- C / C++ (un solo servidor para ambos)
  clangd = {
    mason = true,
    config = {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
      },
      -- none-ls usa UTF-16; fijarlo en clangd evita el aviso
      -- "multiple different client offset_encodings" al formatear.
      capabilities = { general = { positionEncodings = { "utf-16" } } },
    },
  },

  -- Go (Mason compila gopls con `go install`, por eso requiere Go)
  gopls = {
    mason = true,
    requires = "go",
    config = {
      settings = {
        gopls = {
          gofumpt = true,
          usePlaceholders = true,
          staticcheck = true,
          analyses = { unusedparams = true, unusedwrite = true },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    },
  },

  -- Rust: rust-analyzer se instala con rustup para que coincida con tu toolchain.
  rust_analyzer = {
    mason = false,
    config = {
      settings = {
        ["rust-analyzer"] = {
          check = { command = "clippy" },
          cargo = { allFeatures = true },
        },
      },
    },
  },

  -- Java: jdtls necesita Java 21+ para ejecutarse y python3 para su script de arranque.
  -- La integración extra (Lombok, depuración) está en lua/plugins/lsp/java.lua.
  jdtls = {
    mason = true,
    requires = { "java", "python3" },
    executable = "jdtls",
    -- Función: se evalúa al activar el LSP, cuando Mason ya definió $MASON.
    config = function()
      -- Bundles de depuración/tests (opcionales): :MasonInstall java-debug-adapter java-test
      local share = vim.fs.joinpath(vim.env.MASON or "", "share")
      local bundles = {}
      local debug_jar = vim.fs.joinpath(share, "java-debug-adapter", "com.microsoft.java.debug.plugin.jar")
      if vim.uv.fs_stat(debug_jar) then
        table.insert(bundles, debug_jar)
        for _, jar in ipairs(vim.fn.glob(vim.fs.joinpath(share, "java-test", "*.jar"), true, true)) do
          -- Estos jars de java-test no son bundles de OSGi y rompen jdtls si se cargan.
          local name = vim.fs.basename(jar)
          if not name:match("com.microsoft.java.test.runner") and not name:match("jacocoagent") then
            table.insert(bundles, jar)
          end
        end
      end
      return { init_options = { bundles = bundles } }
    end,
  },

  -- Markdown
  marksman = { mason = true },

  -- SQL genérico (lee conexiones de config.yml del proyecto)
  sqls = { mason = true, requires = "go" },

  -- PostgreSQL: sólo se activa en proyectos con postgres-language-server.jsonc
  postgres_lsp = { mason = true },

  -- Dart / Flutter: dartls viene con el SDK de Dart. Si `flutter` existe,
  -- flutter-tools.nvim lo gestiona (lua/plugins/lsp/flutter.lua) y aquí se omite.
  dartls = { mason = false, skip_if = "flutter" },
}

-- Herramientas de Mason que no son servidores LSP.
-- Las que no están aquí se instalan fuera de Mason (ver README):
--   rustfmt / clippy  → rustup component add rustfmt clippy rust-analyzer
--   dart format       → SDK de Dart/Flutter
--   formateo de Java  → integrado en jdtls
M.tools = {
  { name = "stylua" }, -- Lua
  { name = "prettier", requires = "npm" }, -- JS/TS/JSON/YAML/CSS/HTML/Markdown
  { name = "black", requires = "python3" }, -- Python
  { name = "isort", requires = "python3" }, -- Python (imports)
  { name = "clang-format", requires = "python3" }, -- C/C++ (Mason lo instala desde PyPI)
  { name = "php-cs-fixer", requires = "php" }, -- PHP
  { name = "gofumpt", requires = "go" }, -- Go
  { name = "goimports", requires = "go" }, -- Go (imports)
  { name = "sql-formatter", requires = "npm" }, -- SQL / PostgreSQL
  { name = "tree-sitter-cli" }, -- requerido por nvim-treesitter (rama main) para compilar parsers
}

---¿Están disponibles los ejecutables que necesita Mason para instalar este paquete?
---@param requires string|string[]|nil
---@return boolean ok, string[] missing
function M.requirements_met(requires)
  if not requires then
    return true, {}
  end
  local missing = {}
  for _, exe in ipairs(type(requires) == "table" and requires or { requires }) do
    if vim.fn.executable(exe) == 0 then
      table.insert(missing, exe)
    end
  end
  return #missing == 0, missing
end

---Nombres (de lspconfig) de los servidores que Mason debe asegurar.
---Omite los que no tienen sus requisitos y devuelve también esa lista.
---@return string[] installable, table<string, string[]> skipped
function M.mason_servers()
  local installable, skipped = {}, {}
  for name, spec in pairs(M.servers) do
    if spec.mason then
      local ok, missing = M.requirements_met(spec.requires)
      if ok then
        table.insert(installable, name)
      else
        skipped[name] = missing
      end
    end
  end
  table.sort(installable)
  return installable, skipped
end

return M
