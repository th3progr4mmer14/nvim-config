-- nvim-treesitter (rama `main`, API nueva para Neovim 0.12).
-- En esta rama el plugin SÓLO instala parsers y queries; el resaltado, el
-- plegado y la indentación se activan explícitamente con vim.treesitter.start().
--
-- Requisitos (ver README): `tree-sitter` CLI ≥ 0.26.1, `tar`, `curl` y un
-- compilador de C. Mason instala tree-sitter-cli automáticamente si falta.

-- Parsers a instalar. Para agregar un lenguaje basta con añadirlo aquí.
-- stylua: ignore
local parsers = {
  -- Lenguajes principales
  "java", "javascript", "typescript", "tsx", "jsdoc", "python", "dart",
  "php", "phpdoc", "c", "cpp", "go", "gomod", "gosum", "gowork", "rust", "lua", "luadoc",
  -- Web
  "html", "css", "json", "yaml", "toml",
  -- Bases de datos y documentación
  "sql", "markdown", "markdown_inline",
  -- Neovim y utilidades (ayuda, queries, git, regex)
  "vim", "vimdoc", "query", "regex", "bash", "diff", "gitcommit", "git_rebase", "gitignore",
  -- De tu config original
  "blade", "ruby",
}

-- Filetypes con indentación por Treesitter (experimental en nvim-treesitter);
-- el resto usa la indentación de Vim, que es más estable en esos lenguajes.
-- stylua: ignore
local ts_indent = {
  c = true, cpp = true, css = true, html = true, java = true, javascript = true,
  typescript = true, typescriptreact = true, javascriptreact = true, lua = true,
  php = true, rust = true, go = true, json = true, yaml = true, dart = true, blade = true,
}

local function install_parsers()
  if vim.fn.executable("tree-sitter") == 0 then
    vim.notify_once(
      "Falta tree-sitter CLI: Mason lo instalará; después ejecuta :TSUpdate (o reinicia).",
      vim.log.levels.WARN,
      { title = "nvim-treesitter" }
    )
    return
  end
  local installed = require("nvim-treesitter").get_installed("parsers")
  local missing = vim.tbl_filter(function(lang)
    return not vim.list_contains(installed, lang)
  end, parsers)
  if #missing > 0 then
    require("nvim-treesitter").install(missing)
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- la rama main no admite carga diferida
    build = ":TSUpdate",
    dependencies = { "mason-org/mason.nvim" }, -- tree-sitter CLI puede venir de Mason
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      vim.schedule(install_parsers)
      -- Cuando Mason termine de instalar tree-sitter-cli, instalar los parsers.
      vim.api.nvim_create_autocmd("User", {
        pattern = "MolliMasonToolInstalled",
        callback = function(args)
          if args.data and args.data.name == "tree-sitter-cli" then
            install_parsers()
          end
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("molli_treesitter", { clear = true }),
        callback = function(args)
          local buf, ft = args.buf, args.match
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang or not vim.treesitter.language.add(lang) then
            return -- no hay parser instalado para este filetype
          end
          if not pcall(vim.treesitter.start, buf, lang) then
            return
          end
          -- Plegado por Treesitter (todo abierto al inicio por foldlevel=99).
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          if ts_indent[ft] then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    -- Cierre y renombrado automático de etiquetas HTML/JSX/Blade (de tu config original).
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
}
