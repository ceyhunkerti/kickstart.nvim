-- =============================================================================
-- config/keymaps.lua — all keymaps (no plugin-specific ones; those live with
-- their plugins)
-- =============================================================================

local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────────────────────
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map({ 'n', 'i' }, '<C-\\>', '<cmd>e .<CR>', { desc = 'Open netrw in current directory' })

-- ── Window navigation ────────────────────────────────────────────────────────
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ── Terminal ─────────────────────────────────────────────────────────────────
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ── Editing helpers ──────────────────────────────────────────────────────────
map('v', '>', '>gv',  { desc = 'Indent and keep selection' })
map('v', '<', '<gv',  { desc = 'Un-indent and keep selection' })
map('n', '<S-w>', 'b', { desc = 'Move back a word' })
map('n', 'yw',   'yaw', { desc = 'Yank a word' })
map('n', 'cw',   'caw', { desc = 'Change a word' })
map('i', '<C-d>', '<Esc>_ddi', { noremap = true, desc = 'Delete line in insert mode' })

-- ── Clipboard ────────────────────────────────────────────────────────────────
map('n', '<leader>x', '"+dd',  { desc = 'Cut line to clipboard' })
map('v', '<leader>x', '"+x',   { desc = 'Cut selection to clipboard' })
map('n', '<leader>Y', 'ggVGy', { desc = 'Copy entire buffer' })

-- ── Delete without yanking ───────────────────────────────────────────────────
map('n', '<leader>d', '"_dd',  { desc = 'Delete line (no yank)' })
map('v', '<leader>d', '"_d',   { desc = 'Delete selection (no yank)' })
map('n', '<leader>D', 'gg"_dG', { desc = 'Delete entire buffer (no yank)' })

-- ── Buffer management ────────────────────────────────────────────────────────
map('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Buffer Close Others' })
map('n', '<leader>ba', '<cmd>%bd<cr>',         { desc = 'Buffer Close All' })

-- ── Search & replace ─────────────────────────────────────────────────────────
map('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>',
  { desc = '[R]eplace all occurrences of word under cursor' })
map('v', '<leader>r', '"hy:%s/<C-r>h//gI<Left><Left><Left>',
  { desc = '[R]eplace all occurrences of visual selection' })

-- Delete ALL occurrences of visual selection
map('v', '<leader>da', function()
  vim.cmd 'normal! "vy'
  local sel = vim.fn.escape(vim.fn.getreg 'v', '/\\')
  vim.cmd('%s/' .. sel .. '//g')
end, { desc = '[D]elete [A]ll occurrences of visual selection' })

-- ── Diagnostics ──────────────────────────────────────────────────────────────
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
