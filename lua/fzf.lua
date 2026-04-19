-- =============================================================================
-- lua/fzf.lua — fzf picker
-- =============================================================================

vim.pack.add {
  'https://github.com/ibhagwan/fzf-lua',
}

vim.defer_fn(function()
  require('fzf-lua').setup {
    defaults = {
      formatter = 'path.filename_first',
    },
    winopts = {
      split = 'botright new',
      height = 0.4,
      width = 1.0,
      ---@diagnostic disable-next-line: missing-fields
      preview = {
        hidden = true,
      },
    },
    fzf_opts = {
      ['--layout'] = 'reverse',
    },
  }
end, 500)
