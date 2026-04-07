-- =============================================================================
-- plugins/editing.lua — text editing enhancements
--   mini.ai, mini.surround, mini.statusline, mini.cursorword
--   guess-indent
-- =============================================================================
-- multi-cursor ---------------------------------------------------------------
vim.pack.add { 'https://github.com/mg979/vim-visual-multi' }
vim.pack.add { 'https://github.com/jake-stewart/multicursor.nvim' }
require('multicursor-nvim').setup {}

-- ── guess-indent ─────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

-- ── mini.nvim ────────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
-- Autopairs
require('mini.pairs').setup {}

-- Better Around/Inside textobjects: va), yinq, ci', …
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings: saiw), sd', sr)'
require('mini.surround').setup {}

-- Highlight all occurrences of word under cursor
require('mini.cursorword').setup {}

-- Disable cursorword flash during yank (looks cluttered)
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('mini-cursorword-yank', { clear = true }),
  callback = function()
    vim.g.minicursorword_disable = true
    vim.defer_fn(function() vim.g.minicursorword_disable = false end, 300)
  end,
})

-- Statusline
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_filename = function() return vim.fn.expand '%:.:P' end

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end
