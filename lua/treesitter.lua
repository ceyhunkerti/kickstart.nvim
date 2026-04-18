
-- =============================================================================
-- plugins/treesitter.lua — syntax, indentation, textobjects, ufo folds
-- Keymaps: config/keymaps.lua (zR, zM)
-- =============================================================================
vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',
}
local parsers = {
  'bash',
  'c',
  'diff',
  'elixir',
  'html',
  'rust',
  'go',
  'groovy',
  'java',
  'javascript',
  'python',
  'typescript',
  'tsx',
  'css',
  'scss',
  'json',
  'json5',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
  'yaml',
}
require('nvim-treesitter').install(parsers)
require('nvim-treesitter').setup {}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-attach', { clear = true }),
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end
    if not vim.treesitter.language.add(lang) then return end
    vim.treesitter.start(buf, lang)
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- textobjects setup
require('nvim-treesitter-textobjects').setup {
  move = { set_jumps = true },
}

local sel = require 'nvim-treesitter-textobjects.select'
local keymaps = {
  ['af'] = '@function.outer',
  ['if'] = '@function.inner',
  ['ac'] = '@class.outer',
  ['ic'] = '@class.inner',
  ['aa'] = '@parameter.outer',
  ['ia'] = '@parameter.inner',
  ['ab'] = '@block.outer',
  ['ib'] = '@block.inner',
  ['ak'] = '@entry.outer',
}
for lhs, query in pairs(keymaps) do
  vim.keymap.set({ 'x', 'o' }, lhs, function() sel.select_textobject(query, 'textobjects') end, { desc = 'Select ' .. query })
end

local mv = require 'nvim-treesitter-textobjects.move'
vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() mv.goto_next_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() mv.goto_previous_start('@function.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, ']c', function() mv.goto_next_start('@class.outer', 'textobjects') end)
vim.keymap.set({ 'n', 'x', 'o' }, '[c', function() mv.goto_previous_start('@class.outer', 'textobjects') end)

-- folds
require('ufo').setup {
  provider_selector = function() return { 'treesitter', 'indent' } end,
}
