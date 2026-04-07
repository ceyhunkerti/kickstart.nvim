-- =============================================================================
-- plugins/ui.lua — colorscheme, statusline, indent guides, devicons, which-key
-- =============================================================================

-- ── gruvbox-material ─────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/sainnhe/gruvbox-material' }

vim.g.gruvbox_material_enable_italic = 0
vim.g.gruvbox_material_disable_italic_comment = 1
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_better_performance = 1
vim.opt.termguicolors = true
vim.cmd.colorscheme 'gruvbox-material'

-- Override indent-blankline highlight groups after the colorscheme loads
vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3d3d3d' })
vim.api.nvim_set_hl(0, 'IblScope', { fg = '#606060' })

-- ── indent-blankline ─────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {
  indent = { char = '▏' },
  scope = { enabled = false },
}

-- ── nvim-web-devicons ────────────────────────────────────────────────────────
if vim.g.have_nerd_font then
  vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' }
  require('nvim-web-devicons').setup {}
end

-- ── which-key ────────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>d', group = '[D]ebug' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

require('vim._core.ui2').enable {}
