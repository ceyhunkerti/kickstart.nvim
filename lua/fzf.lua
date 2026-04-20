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
      height = 0.3,
      width = 1.0,
      ---@diagnostic disable-next-line: missing-fields
      preview = {
        hidden = true,
      },
    },
    grep = {
      rg_opts = '--column --line-number --no-heading --color=always --ignore-case --max-columns=4096 -e',
    },
    fzf_opts = {
      ['--layout'] = 'reverse',
      ['--height'] = '20%',
    },
  }

  -- Register fzf-lua as the UI select handler
  require('fzf-lua').register_ui_select()
end, 500)
