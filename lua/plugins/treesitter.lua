-- =============================================================================
-- plugins/treesitter.lua — syntax highlighting, indentation, textobjects, folds
-- =============================================================================

vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

-- ── Parser list ──────────────────────────────────────────────────────────────
local parsers = {
  'bash', 'c', 'diff', 'elixir', 'html',
  'lua', 'luadoc', 'markdown', 'markdown_inline',
  'query', 'rust', 'vim', 'vimdoc', 'yaml',
}
require('nvim-treesitter').install(parsers)

-- Enable highlighting + indentation for every filetype that has a parser
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
  callback = function(args)
    local buf  = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end
    if not vim.treesitter.language.add(lang) then return end
    vim.treesitter.start(buf, lang)
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- ── Textobjects ──────────────────────────────────────────────────────────────
require('nvim-treesitter-textobjects').setup {
  select = {
    enable    = true,
    lookahead = true,
    keymaps   = {
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
      ['aa'] = '@parameter.outer',
      ['ia'] = '@parameter.inner',
      ['ab'] = '@block.outer',
      ['ib'] = '@block.inner',
      ['ak'] = '@entry.outer',
    },
  },
  move = {
    enable    = true,
    set_jumps = true,
    goto_next_start     = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
    goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
  },
}

-- ── UFO folding (treesitter-powered) ─────────────────────────────────────────
vim.pack.add({
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',
})

vim.o.foldcolumn     = '0'
vim.o.foldlevel      = 99
vim.o.foldlevelstart = 99

local ufo = require 'ufo'
ufo.setup {
  provider_selector = function() return { 'treesitter', 'indent' } end,
}
vim.keymap.set('n', 'zR', ufo.openAllFolds,  { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
