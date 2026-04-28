-- =============================================================================
-- editing.lua — text editing enhancements
-- =============================================================================

vim.pack.add { 'https://github.com/folke/flash.nvim' }
vim.pack.add { 'https://github.com/mg979/vim-visual-multi' }
vim.pack.add { 'https://github.com/jake-stewart/multicursor.nvim' }
require('multicursor-nvim').setup {}
require('flash').setup {}

vim.pack.add { 'https://github.com/NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
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

vim.pack.add { 'https://github.com/okuuva/auto-save.nvim' }
require('auto-save').setup {
  debounce_delay = 2000,
  condition = function(buf) return vim.bo[buf].filetype ~= 'oil' and vim.bo[buf].modifiable and not vim.bo[buf].readonly end,
}

vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

vim.pack.add { 'https://github.com/nvim-pack/nvim-spectre' }
require('spectre').setup {}

vim.pack.add {
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = 'v2.4.1' },
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.1' },
}

-- LuaSnip build step for regex snippet support (skip on Windows / no make)
if vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
  vim.fn.system { 'make', '-C', vim.fn.stdpath 'data' .. '/site/pack/core/opt/LuaSnip', 'install_jsregexp' }
end
require('blink.cmp').setup {
  keymap = { preset = 'super-tab' },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 1200 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = {
    implementation = 'lua',
    sorts = { 'score', 'sort_text' },
  },
  signature = { enabled = true },
}

vim.pack.add { 'https://github.com/m4xshen/hardtime.nvim' }
require('hardtime').setup {
  max_count = 1000,
}
