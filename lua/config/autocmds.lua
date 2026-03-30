-- =============================================================================
-- config/autocmds.lua — all autocommands
-- =============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight text briefly after yanking
autocmd('TextYankPost', {
  desc  = 'Highlight when yanking (copying) text',
  group = augroup('hl-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Auto-create parent directories on save (skip oil buffers)
autocmd('BufWritePre', {
  group = augroup('auto-mkdir', { clear = true }),
  callback = function(event)
    if vim.bo[event.buf].filetype == 'oil' then return end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})
