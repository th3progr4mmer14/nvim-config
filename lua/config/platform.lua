-- Detección de sistema operativo y utilidades portables (Fedora / macOS).
-- Ningún módulo debe usar rutas absolutas: todo se resuelve con stdpath(),
-- $HOME o el PATH del sistema.

local M = {}

local uname = vim.uv.os_uname()

M.sysname = uname.sysname -- "Linux", "Darwin", "Windows_NT"
M.is_mac = M.sysname == "Darwin"
M.is_linux = M.sysname == "Linux"
M.is_windows = M.sysname:find("Windows") ~= nil
M.is_wsl = M.is_linux and (uname.release:lower():find("microsoft") ~= nil)
M.is_apple_silicon = M.is_mac and uname.machine == "arm64"

---Devuelve true si el ejecutable existe en el PATH.
---@param exe string
---@return boolean
function M.has(exe)
  return vim.fn.executable(exe) == 1
end

---Devuelve el primer ejecutable disponible de la lista, o nil.
---@param candidates string[]
---@return string|nil
function M.first_executable(candidates)
  for _, exe in ipairs(candidates) do
    if M.has(exe) then
      return exe
    end
  end
  return nil
end

---Comando de `fd` según la distribución: Fedora y Homebrew lo instalan como `fd`;
---Debian/Ubuntu lo renombran a `fdfind`.
---@return string|nil
function M.fd_command()
  return M.first_executable({ "fd", "fdfind" })
end

---Proveedor de portapapeles esperado según el sistema, para diagnosticar problemas.
---@return string|nil provider, string|nil hint
function M.clipboard_provider()
  if M.is_mac then
    return M.has("pbcopy") and "pbcopy" or nil, "pbcopy viene con macOS"
  end
  if M.is_wsl then
    return M.first_executable({ "win32yank.exe", "clip.exe" }), "instala win32yank"
  end
  if vim.env.WAYLAND_DISPLAY then
    return M.has("wl-copy") and "wl-copy" or nil, "sudo dnf install wl-clipboard"
  end
  return M.first_executable({ "xclip", "xsel" }), "sudo dnf install xclip"
end

return M
