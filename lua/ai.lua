vim.pack.add { 'https://github.com/supermaven-inc/supermaven-nvim' }
require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<M-a>',
    clear_suggestion = '<M-d>',
  },
}

