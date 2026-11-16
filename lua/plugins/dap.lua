-- Depuración con nvim-dap + nvim-dap-ui. Se carga sólo al usar un atajo de
-- depuración (o cuando otro plugin, como nvim-jdtls, hace require("dap")).
-- Los adaptadores por lenguaje están en lua/config/dap/adapters.lua.
local function dap_call(method, ...)
  local args = { ... }
  return function()
    require("dap")[method](unpack(args))
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    },
    keys = {
      -- Teclas de función (estilo IDE). En macOS usa fn + F5…F12 o activa
      -- "Usar F1, F2, etc. como teclas de función estándar".
      { "<F5>", dap_call("continue"), desc = "Depurar: iniciar / continuar" },
      { "<F10>", dap_call("step_over"), desc = "Depurar: saltar línea" },
      { "<F11>", dap_call("step_into"), desc = "Depurar: entrar" },
      { "<F12>", dap_call("step_out"), desc = "Depurar: salir" },
      -- Breakpoints
      { "<leader>b", dap_call("toggle_breakpoint"), desc = "Depurar: alternar breakpoint" },
      {
        "<leader>B",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condición: "))
        end,
        desc = "Depurar: breakpoint condicional",
      },
      -- Prefijo <leader>x (no <leader>d, que ya muestra el diagnóstico)
      { "<leader>xc", dap_call("continue"), desc = "Depurar: iniciar / continuar" },
      { "<leader>xl", dap_call("run_last"), desc = "Depurar: repetir última sesión" },
      {
        "<leader>xr",
        function()
          require("dap").repl.open()
        end,
        desc = "Depurar: abrir REPL",
      },
      { "<leader>xt", dap_call("terminate"), desc = "Depurar: terminar" },
      { "<leader>xC", dap_call("run_to_cursor"), desc = "Depurar: ejecutar hasta el cursor" },
      {
        "<leader>xu",
        function()
          require("dapui").toggle()
        end,
        desc = "Depurar: alternar interfaz",
      },
      {
        "<leader>xe",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "x" },
        desc = "Depurar: evaluar expresión",
      },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      local icons = vim.g.have_nerd_font
          and {
            breakpoint = "\u{f111}",
            condition = "\u{f059}",
            rejected = "\u{f05e}",
            log = "\u{f05a}",
            stopped = "󰁕",
          }
        or { breakpoint = "B", condition = "C", rejected = "R", log = "L", stopped = ">" }
      vim.fn.sign_define("DapBreakpoint", { text = icons.breakpoint, texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = icons.condition, texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapBreakpointRejected", { text = icons.rejected, texthl = "DiagnosticError" })
      vim.fn.sign_define("DapLogPoint", { text = icons.log, texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = icons.stopped, texthl = "DapStopped", linehl = "DapStoppedLine" })

      dapui.setup()
      -- Abrir/cerrar la interfaz automáticamente con la sesión.
      dap.listeners.after.event_initialized["molli_dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["molli_dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["molli_dapui"] = function()
        dapui.close()
      end

      require("config.dap.adapters").setup()
    end,
  },
}
