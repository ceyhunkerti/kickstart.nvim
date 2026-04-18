-- =============================================================================
-- dap.lua — nvim-dap, dap-ui, codelldb (Rust debug)
-- =============================================================================
vim.pack.add {
  'nvim-neotest/nvim-nio',
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
}

require('mason-tool-installer').setup { ensure_installed = { 'codelldb' } }

-- Defer setup until after plugins load
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local dap = require('dap')
    local dapui = require('dapui')

    dapui.setup()

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
      },
    }

    dap.configurations.rust = {
      {
        name = 'Launch binary',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local cwd = vim.fn.getcwd()
          local default = cwd .. '/target/debug/' .. vim.fn.fnamemodify(cwd, ':t')
          if vim.fn.executable(default) == 1 then return default end
          return vim.fn.input('Path to executable: ', cwd .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
})
