-- =============================================================================
-- plugins/git.lua — gitsigns, lazygit
-- Keymaps: config/keymaps.lua (<leader>gg)
-- =============================================================================

vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
vim.pack.add { 'https://github.com/NeogitOrg/neogit' }
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('neogit').setup {
  integrations = {
    diffview = true,
  },
}
require('gitsigns').setup {}
