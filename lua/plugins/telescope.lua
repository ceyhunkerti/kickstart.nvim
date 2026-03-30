-- =============================================================================
-- plugins/telescope.lua — fuzzy finder + fzf-native + ui-select
-- =============================================================================

vim.pack.add({
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
})

-- fzf-native needs a build step; use table spec for that
vim.pack.add({
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
})

local telescope = require 'telescope'
local actions   = require 'telescope.actions'
local builtin   = require 'telescope.builtin'
local themes    = require 'telescope.themes'

telescope.setup {
  defaults = {
    mappings = {
      i = { ['<C-d>'] = actions.delete_buffer },
      n = { ['d']     = actions.delete_buffer },
    },
  },
  extensions = {
    ['ui-select'] = { themes.get_dropdown() },
  },
}

pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, 'ui-select')

-- ── Keymaps ──────────────────────────────────────────────────────────────────
local map = vim.keymap.set

map('n', '<leader>sh', builtin.help_tags,          { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', builtin.keymaps,             { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', builtin.find_files,          { desc = '[S]earch [F]iles' })
map('n', '..',         builtin.find_files,          { desc = '[S]earch [F]iles (shortcut)' })
map('n', '<leader>ss', builtin.builtin,             { desc = '[S]earch [S]elect Telescope' })
map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', builtin.live_grep,           { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', builtin.diagnostics,         { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', builtin.resume,              { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', builtin.oldfiles,            { desc = '[S]earch Recent Files' })
map('n', '<leader>sc', builtin.commands,            { desc = '[S]earch [C]ommands' })
map('n', '<leader><leader>', builtin.buffers,       { desc = '[ ] Find existing buffers' })

map('n', '<leader>sF', function()
  builtin.find_files { cwd = '/', hidden = true }
end, { desc = '[S]earch [F]iles from root (/)' })

map('n', '<leader>sn', function()
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

map('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(themes.get_dropdown { winblend = 10, previewer = false })
end, { desc = '[/] Fuzzily search in current buffer' })

map('n', '<leader>s/', function()
  builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
end, { desc = '[S]earch [/] in Open Files' })

-- ── LSP pickers wired up per-buffer on LspAttach ─────────────────────────────
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    map('n', 'grr', builtin.lsp_references,               { buffer = buf, desc = '[G]oto [R]eferences' })
    map('n', 'gri', builtin.lsp_implementations,          { buffer = buf, desc = '[G]oto [I]mplementation' })
    map('n', 'grd', builtin.lsp_definitions,              { buffer = buf, desc = '[G]oto [D]efinition' })
    map('n', 'gO',  builtin.lsp_document_symbols,         { buffer = buf, desc = 'Open Document Symbols' })
    map('n', 'gW',  builtin.lsp_dynamic_workspace_symbols,{ buffer = buf, desc = 'Open Workspace Symbols' })
    map('n', 'grt', builtin.lsp_type_definitions,         { buffer = buf, desc = '[G]oto [T]ype Definition' })
  end,
})
