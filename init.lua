-- =============================================================================
-- init.lua — entry point
-- Sets leader keys (must happen before any plugin loads), then requires all
-- config modules and plugin specs in order.
-- =============================================================================

-- Leader keys must be set before any plugin is sourced
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- Nerd Font flag — flip to true if your terminal uses a Nerd Font
vim.g.have_nerd_font = true

-- ── Core config ──────────────────────────────────────────────────────────────
require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.diagnostics')

-- ── Plugins (vim.pack) ───────────────────────────────────────────────────────
require('plugins.ui')          -- colorscheme, statusline, indent guides, icons
require('plugins.editing')     -- mini.ai, mini.surround, guess-indent, autopairs
require('plugins.git')         -- gitsigns, lazygit
require('plugins.telescope')   -- fuzzy finder + LSP pickers
require('plugins.treesitter')  -- syntax, textobjects, folds
require('plugins.lsp')         -- mason, lspconfig, fidget, conform
require('plugins.completion')  -- blink.cmp, luasnip
require('plugins.dap')         -- nvim-dap, dap-ui, codelldb (Rust debug)
require('plugins.tools')       -- oil, spectre, csvview, render-markdown, ufo, auto-save, todo-comments, supermaven

-- vim: ts=2 sts=2 sw=2 et
