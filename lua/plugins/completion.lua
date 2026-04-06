-- =============================================================================
-- plugins/completion.lua — autocompletion + snippets
--   blink.cmp  — completion engine
--   LuaSnip    — snippet engine
-- =============================================================================

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
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
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
