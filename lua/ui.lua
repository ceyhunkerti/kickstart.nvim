-- =============================================================================
-- plugins/ui.lua — colorscheme, statusline, indent guides, devicons, which-key
-- =============================================================================

-- ── gruvbox-material ─────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/sainnhe/gruvbox-material' }

vim.g.gruvbox_material_enable_italic = 0
vim.g.gruvbox_material_disable_italic_comment = 1
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_treesitter = 1
vim.opt.termguicolors = true
vim.cmd.colorscheme 'gruvbox-material'
vim.api.nvim_set_hl(0, 'TSString', { link = 'String' })
vim.api.nvim_set_hl(0, 'String', { fg = '#9ccc65' })

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

-- ── lualine ────────────────────────────────────────────────────────────────
vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
}

require('lualine').setup {
  options = {
    icons_enabled = vim.g.have_nerd_font,
    theme = 'gruvbox-material',
    section_separators = '', -- removes the > arrows
    component_separators = '', -- removes the inner separators too
  },
  sections = {
    lualine_c = { { 'filename', path = 1 } }, -- 1 = relative path
    lualine_x = { 'diagnostics', 'filetype' },
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        max_length = vim.o.columns, -- use full width
      },
    },
    lualine_z = {},
  },
}

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require('oil').setup {
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = false,
}



vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
}
require('neo-tree').setup {
  filesystem = {
    follow_current_file = { enabled = true, leave_dirs_open = true },
    filtered_items = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = false,
      always_show_by_pattern = { '.env*' },
      hide_by_name = { 'node_modules', 'venv', '.venv' },
      never_show_by_pattern = { '*.pyc', '*.pyo', '*/__pycache__' },
    },
  },
}

-- require('vim._core.ui2').enable {}
