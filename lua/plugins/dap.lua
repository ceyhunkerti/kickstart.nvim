-- =============================================================================
-- plugins/dap.lua — Debug Adapter Protocol (Rust / codelldb)
--
--   Prerequisites:
--     rustup component add rust-analyzer   (LSP, managed outside Mason)
--     rustup component add rustfmt         (formatter)
--     codelldb is auto-installed by Mason on first launch.
--
--   Keymaps (<leader>d…):
--     <leader>db  toggle breakpoint
--     <leader>dc  continue / start session
--     <leader>ds  step over
--     <leader>di  step into
--     <leader>do  step out
--     <leader>du  toggle UI panels
--     <leader>dq  terminate session
-- =============================================================================

vim.pack.add({
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
})

-- Ensure codelldb is installed via Mason
-- mason-tool-installer is idempotent, so calling setup again is safe
require('mason-tool-installer').setup {
  ensure_installed = { 'codelldb' },
}

local dap   = require 'dap'
local dapui = require 'dapui'

dapui.setup {}

-- Auto open/close UI when a session starts/ends
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config']     = dapui.close

-- ── codelldb adapter ─────────────────────────────────────────────────────────
dap.adapters.codelldb = {
  type       = 'server',
  port       = '${port}',
  executable = {
    command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
    args    = { '--port', '${port}' },
  },
}

-- ── Rust debug configuration ─────────────────────────────────────────────────
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

-- ── Keymaps ──────────────────────────────────────────────────────────────────
local map = vim.keymap.set
map('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug toggle [B]reakpoint' })
map('n', '<leader>dc', dap.continue,          { desc = '[D]ebug [C]ontinue / Start' })
map('n', '<leader>ds', dap.step_over,         { desc = '[D]ebug [S]tep over' })
map('n', '<leader>di', dap.step_into,         { desc = '[D]ebug Step [I]nto' })
map('n', '<leader>do', dap.step_out,          { desc = '[D]ebug Step [O]ut' })
map('n', '<leader>du', dapui.toggle,          { desc = '[D]ebug [U]I toggle' })
map('n', '<leader>dq', dap.terminate,         { desc = '[D]ebug [Q]uit' })
