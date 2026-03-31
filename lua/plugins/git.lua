-- =============================================================================
-- plugins/git.lua — gitsigns, lazygit
-- Keymaps: config/keymaps.lua (<leader>gg)
-- =============================================================================

vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })
vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })
vim.pack.add({ 'https://github.com/kdheepak/lazygit.nvim' })

require('gitsigns').setup {}
