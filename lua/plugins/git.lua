-- =============================================================================
-- plugins/git.lua — git integration
--   gitsigns  — gutter signs + hunk utilities
--   lazygit   — full TUI git client
-- =============================================================================

-- plenary is a shared dependency used by telescope, lazygit, spectre, etc.
-- Load it once here; subsequent vim.pack.add calls for the same URL are no-ops.
vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })

-- ── gitsigns ─────────────────────────────────────────────────────────────────
vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
require('gitsigns').setup {}

-- ── lazygit ──────────────────────────────────────────────────────────────────
vim.pack.add({ 'https://github.com/kdheepak/lazygit.nvim' })
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
