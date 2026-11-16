-- Tema de lualine generado desde la paleta (lua/config/colors.lua).
-- Cada modo tiene su color de marca en la sección "a".
local M = {}

function M.build()
  local c = require("config.colors")
  local r = c.roles
  local b_bg = c.base.surface
  local c_bg = r.bg_deep

  local function mode(color)
    return {
      a = { fg = r.bg_deep, bg = color, gui = "bold" },
      b = { fg = color, bg = b_bg },
      c = { fg = r.fg_dim, bg = c_bg },
    }
  end

  return {
    normal = mode(r.mode_normal),
    insert = mode(r.mode_insert),
    visual = mode(r.mode_visual),
    replace = mode(r.mode_replace),
    command = mode(r.mode_command),
    terminal = mode(r.mode_terminal),
    inactive = {
      a = { fg = r.line_nr, bg = c_bg },
      b = { fg = r.line_nr, bg = c_bg },
      c = { fg = r.line_nr, bg = c_bg },
    },
  }
end

return M
