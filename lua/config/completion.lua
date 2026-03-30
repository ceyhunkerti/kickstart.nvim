-- =============================================================================
-- plugins/completion.lua — autocompletion + snippets
--   blink.cmp  — completion engine
--   LuaSnip    — snippet engine
-- =============================================================================

vim.pack.add {
  src     = 'https://github.com/L3MON4D3/LuaSnip',
  name    = 'luasnip',
  version = '2.4.1',
  -- build step needed for regex snippet support (skipped on Windows / no make)
  build   = (vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0)
              and nil
              or 'make install_jsregexp',
}

vim.pack.add {
  src     = 'https://github.com/saghen/blink.cmp',
  name    = 'blink-cmp',
  version = '1.10.0',
}

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
    sorts          = { 'score', 'sort_text' },
  },

  signature = { enabled = true },
}
