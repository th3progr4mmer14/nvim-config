-- Dart / Flutter con flutter-tools.nvim.
-- flutter-tools localiza el SDK de Flutter (PATH o FVM), arranca el servidor
-- dartls con el `dart` de ESE SDK y añade comandos :FlutterRun, :FlutterDevices,
-- hot reload, etc. Sólo se activa si `flutter` está en el PATH; si únicamente
-- tienes el SDK de Dart, se usa dartls directo (lua/config/lsp/servers.lua).
return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    cond = function()
      return vim.fn.executable("flutter") == 1
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<CR>", ft = "dart", desc = "Flutter: run" },
      { "<leader>Fq", "<cmd>FlutterQuit<CR>", ft = "dart", desc = "Flutter: quit" },
      { "<leader>FR", "<cmd>FlutterRestart<CR>", ft = "dart", desc = "Flutter: hot restart" },
      { "<leader>Fl", "<cmd>FlutterReload<CR>", ft = "dart", desc = "Flutter: hot reload" },
      { "<leader>Fd", "<cmd>FlutterDevices<CR>", ft = "dart", desc = "Flutter: dispositivos" },
      { "<leader>Fe", "<cmd>FlutterEmulators<CR>", ft = "dart", desc = "Flutter: emuladores" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<CR>", ft = "dart", desc = "Flutter: outline" },
      { "<leader>Fg", "<cmd>FlutterLogToggle<CR>", ft = "dart", desc = "Flutter: log" },
    },
    config = function()
      require("flutter-tools").setup({
        ui = { border = "rounded" },
        fvm = vim.uv.fs_stat(".fvm") ~= nil, -- usa .fvm/flutter_sdk si el proyecto lo define
        closing_tags = { highlight = "Comment", prefix = "// " },
        dev_log = { enabled = true, open_cmd = "15split" },
        -- Depuración de Dart/Flutter con nvim-dap (adaptador incluido en el SDK).
        debugger = { enabled = true },
        lsp = {
          capabilities = require("config.lsp.capabilities").get(),
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            updateImportsOnRename = true,
          },
        },
      })
    end,
  },
}
