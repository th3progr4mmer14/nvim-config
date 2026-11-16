-- Autocompletado con blink.cmp + friendly-snippets.
-- blink.cmp incluye su propio motor de snippets (usa vim.snippet), así que no
-- hacen falta nvim-cmp ni LuaSnip.
return {
  {
    "saghen/blink.cmp",
    -- Etiqueta de versión = descarga el binario precompilado del matcher en Rust
    -- (no requiere cargo). Linux x86_64 y macOS arm64 tienen binario oficial.
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'super-tab' (de tu config original): Tab acepta / salta en snippets.
      -- Atajos del preset:
      --   <C-space> abrir menú / alternar documentación   <C-e> cerrar
      --   <Tab>/<S-Tab> aceptar o saltar en snippet        <C-n>/<C-p> o ↑/↓ navegar
      --   <C-b>/<C-f> desplazar documentación              <C-k> alternar firma
      keymap = { preset = "super-tab" },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = {
        menu = {
          border = "rounded",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
        },
        documentation = {
          auto_show = true, -- igual que en tu config original
          auto_show_delay_ms = 250,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = false },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
