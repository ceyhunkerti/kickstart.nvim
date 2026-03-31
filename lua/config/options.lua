-- =============================================================================
-- config/options.lua — all vim.o / vim.opt settings
-- =============================================================================

vim.o.number = true
vim.o.relativenumber = false
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.laststatus = 3 -- global statusline
vim.o.report = 9999
vim.o.shortmess = vim.o.shortmess .. 'W'
vim.o.whichwrap = 'h,l,<,>,[,]'

vim.opt.cmdheight = 0
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.tabstop = 2 -- tab width
vim.o.shiftwidth = 2 -- indent width
vim.o.softtabstop = 2 -- spaces inserted when pressing tab

-- Clipboard sync — scheduled to avoid slowing startup
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
