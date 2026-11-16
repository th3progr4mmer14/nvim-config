-- Navegación transparente entre ventanas de Neovim y paneles de tmux.
-- Sólo se carga si Neovim corre dentro de tmux ($TMUX definido). Fuera de tmux,
-- Ctrl+h/j/k/l los define lua/config/keymaps.lua con <C-w>h/j/k/l.
--
-- Requiere el bloque correspondiente en ~/.tmux.conf (ver README → tmux).
return {
  {
    "alexghergh/nvim-tmux-navigation",
    cond = function()
      return vim.env.TMUX ~= nil
    end,
    event = "VeryLazy",
    opts = {
      disable_when_zoomed = true, -- de tu config original
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        last_active = "<C-\\>",
        next = "<C-Space>", -- modo normal; Blink usa <C-Space> sólo en modo inserción, no chocan
      },
    },
  },
}
