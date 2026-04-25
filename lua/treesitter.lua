-- =============================================================================
-- lua/treesitter.lua — folding with ufo
-- Keymaps: config/keymaps.lua (zR, zM)
-- =============================================================================

vim.pack.add {
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',
}

vim.schedule(function()
  -- folds setup only
  require('ufo').setup {
    provider_selector = function() return { 'indent' } end,
  }
end)
