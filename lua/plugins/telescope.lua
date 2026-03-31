-- =============================================================================
-- plugins/telescope.lua — fuzzy finder + fzf-native + ui-select
-- Keymaps: config/keymaps.lua (<leader>s*, .., <leader>/, grr, gri, grd, …)
-- =============================================================================

vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
})

local telescope = require 'telescope'
local actions   = require 'telescope.actions'

telescope.setup {
  defaults = {
    mappings = {
      i = { ['<C-d>'] = actions.delete_buffer },
      n = { ['d']     = actions.delete_buffer },
    },
  },
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}

pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, 'ui-select')
