-- =============================================================================
-- plugins/dap.lua — nvim-dap, dap-ui, codelldb (Rust debug)
-- Keymaps: config/keymaps.lua (<leader>db/dc/ds/di/do/du/dq)
-- =============================================================================

vim.pack.add({
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
})

require('mason-tool-installer').setup { ensure_installed = { 'codelldb' } }

local dap   = require 'dap'
local dapui = require 'dapui'

dapui.setup {}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config']     = dapui.close

dap.adapters.codelldb = {
  type       = 'server',
  port       = '${port}',
  executable = {
    command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
    args    = { '--port', '${port}' },
  },
}

dap.configurations.rust = {
  {
    name        = 'Launch binary',
    type        = 'codelldb',
    request     = 'launch',
    program     = function()
      local cwd     = vim.fn.getcwd()
      local default = cwd .. '/target/debug/' .. vim.fn.fnamemodify(cwd, ':t')
      if vim.fn.executable(default) == 1 then return default end
      return vim.fn.input('Path to executable: ', cwd .. '/target/debug/', 'file')
    end,
    cwd         = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
