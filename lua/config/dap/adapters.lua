-- Adaptadores y configuraciones de depuración (nvim-dap).
--
-- Ningún depurador se instala automáticamente: varios necesitan un SDK
-- (Python, Go, Node, Java) y no todos los proyectos los usan. Cada adaptador se
-- registra SOLO si su ejecutable existe. Instalación (README → Depuración):
--
--   Python      :MasonInstall debugpy                        (requiere python3)
--   Go          :MasonInstall delve                          (requiere go)
--   C / C++     :MasonInstall codelldb                       (requiere compilador; en macOS Xcode CLT)
--   JS / TS     :MasonInstall js-debug-adapter               (requiere node)
--   Java        :MasonInstall java-debug-adapter java-test   (lo registra nvim-jdtls)
--   Dart/Flutter → incluido en el SDK; lo registra flutter-tools.nvim
local M = {}

local function has(exe)
  return vim.fn.executable(exe) == 1
end

---Python del proyecto: venv activo → .venv/venv locales → python3 del sistema.
local function python_path()
  local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
  if venv then
    return vim.fs.joinpath(venv, "bin", "python")
  end
  for _, dir in ipairs({ ".venv", "venv" }) do
    local candidate = vim.fs.joinpath(vim.fn.getcwd(), dir, "bin", "python")
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or "python"
end

local function ask_program()
  return vim.fn.input("Ejecutable: ", vim.fn.getcwd() .. "/", "file")
end

local function ask_args()
  return vim.split(vim.fn.input("Argumentos: "), " ", { trimempty = true })
end

function M.setup()
  local dap = require("dap")

  -- ── Python (debugpy) ─────────────────────────────────────────
  if has("debugpy-adapter") then
    dap.adapters.python = { type = "executable", command = "debugpy-adapter" }
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Python: archivo actual",
        program = "${file}",
        console = "integratedTerminal",
        pythonPath = python_path,
      },
      {
        type = "python",
        request = "launch",
        name = "Python: archivo actual con argumentos",
        program = "${file}",
        args = ask_args,
        console = "integratedTerminal",
        pythonPath = python_path,
      },
    }
  end

  -- ── Go (delve) ──────────────────────────────────────────────
  if has("dlv") then
    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = { command = "dlv", args = { "dap", "-l", "127.0.0.1:${port}" } },
    }
    dap.configurations.go = {
      { type = "go", name = "Go: archivo actual", request = "launch", program = "${file}" },
      { type = "go", name = "Go: paquete actual", request = "launch", program = "${fileDirname}" },
      { type = "go", name = "Go: tests del paquete", request = "launch", mode = "test", program = "${fileDirname}" },
    }
  end

  -- ── C / C++ / Rust (codelldb) ───────────────────────────────
  if has("codelldb") then
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = { command = "codelldb", args = { "--port", "${port}" } },
    }
    local native = {
      {
        type = "codelldb",
        request = "launch",
        name = "Ejecutar binario (compílalo con -g)",
        program = ask_program,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.c = native
    dap.configurations.cpp = native
    dap.configurations.rust = native
  end

  -- ── JavaScript / TypeScript (vscode-js-debug) ───────────────
  if has("js-debug-adapter") then
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = { command = "js-debug-adapter", args = { "${port}" } },
    }
    local js = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Node: archivo actual",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Node: adjuntar a proceso (--inspect)",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }
    for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
      dap.configurations[ft] = js
    end
  end

  -- Java: nvim-jdtls registra el adaptador `java` al adjuntarse jdtls, si están
  -- los bundles de java-debug-adapter/java-test (ver lua/config/lsp/servers.lua).
end

return M
