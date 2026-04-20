-- =============================================================================
-- init.lua — entry point
-- Sets leader keys (must happen before any plugin loads), then requires all
-- config modules and plugin specs in order.
-- =============================================================================

-- Leader keys must be set before any plugin is sourced
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font flag — flip to true if your terminal uses a Nerd Font
vim.g.have_nerd_font = true

require 'options'
require 'ui'
require 'editing'
require 'git'
-- require 'telescope'
require 'fzf'
require 'keymaps'
require 'autocmds'
require 'diagnostics'
require 'treesitter'
require 'lsp'
require 'ai'
require 'dap'
