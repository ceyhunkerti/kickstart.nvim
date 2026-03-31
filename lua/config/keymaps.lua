-- =============================================================================
-- config/keymaps.lua — ALL keymaps (core + plugin)
-- =============================================================================

local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────────────────────
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map({ 'n', 'i' }, '<C-\\>', '<cmd>e .<CR>', { desc = 'Open netrw in current directory' })

-- ── Window navigation ────────────────────────────────────────────────────────
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ── Terminal ─────────────────────────────────────────────────────────────────
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ── Editing helpers ──────────────────────────────────────────────────────────
map('v', '>', '>gv', { desc = 'Indent and keep selection' })
map('v', '<', '<gv', { desc = 'Un-indent and keep selection' })
map('n', '<S-w>', 'b', { desc = 'Move back a word' })
map('n', 'yw', 'yaw', { desc = 'Yank a word' })
map('n', 'cw', 'caw', { desc = 'Change a word' })
map('i', '<C-d>', '<Esc>_ddi', { noremap = true, desc = 'Delete line in insert mode' })
map('n', 'dw', 'daw', { desc = 'Delete a word' })

-- ── Clipboard ────────────────────────────────────────────────────────────────
map('n', '<leader>x', '"+dd', { desc = 'Cut line to clipboard' })
map('v', '<leader>x', '"+x', { desc = 'Cut selection to clipboard' })
map('n', '<leader>Y', 'ggVGy', { desc = 'Copy entire buffer' })

-- ── Delete without yanking ───────────────────────────────────────────────────
map('n', '<leader>d', '"_dd', { desc = 'Delete line (no yank)' })
map('v', '<leader>d', '"_d', { desc = 'Delete selection (no yank)' })
map('n', '<leader>D', 'gg"_dG', { desc = 'Delete entire buffer (no yank)' })

-- ── Buffer management ────────────────────────────────────────────────────────
map('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Buffer Close Others' })
map('n', '<leader>ba', '<cmd>%bd<cr>', { desc = 'Buffer Close All' })

-- ── Search & replace ─────────────────────────────────────────────────────────
map('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = '[R]eplace all occurrences of word under cursor' })
map('v', '<leader>r', '"hy:%s/<C-r>h//gI<Left><Left><Left>', { desc = '[R]eplace all occurrences of visual selection' })

map('v', '<leader>da', function()
  vim.cmd 'normal! "vy'
  local sel = vim.fn.escape(vim.fn.getreg 'v', '/\\')
  vim.cmd('%s/' .. sel .. '//g')
end, { desc = '[D]elete [A]ll occurrences of visual selection' })

-- ── Diagnostics ──────────────────────────────────────────────────────────────
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- ── LSP (buffer-local, registered on LspAttach) ──────────────────────────────
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('keymaps-lsp-attach', { clear = true }),
  callback = function(event)
    local function lmap(keys, func, desc, mode) vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end
    lmap('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    lmap('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    lmap('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      lmap('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- ── Telescope ────────────────────────────────────────────────────────────────
-- Registered after telescope loads (deferred so builtin is available)
vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopeLoaded',
  once = true,
  callback = function() require 'config.keymaps_telescope' end,
})
-- Telescope is loaded eagerly, so just call it directly after init
vim.defer_fn(function()
  local ok, builtin = pcall(require, 'telescope.builtin')
  if not ok then return end
  local themes = require 'telescope.themes'

  map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  map('n', '..', builtin.find_files, { desc = '[S]earch [F]iles (shortcut)' })
  map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
  map('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  map('n', '<leader>sF', function() builtin.find_files { cwd = '/', hidden = true } end, { desc = '[S]earch [F]iles from root (/)' })

  map('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

  map(
    'n',
    '<leader>/',
    function() builtin.current_buffer_fuzzy_find(themes.get_dropdown { winblend = 10, previewer = false }) end,
    { desc = '[/] Fuzzily search in current buffer' }
  )

  map(
    'n',
    '<leader>s/',
    function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
    { desc = '[S]earch [/] in Open Files' }
  )
end, 0)

-- Telescope LSP pickers (buffer-local)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('keymaps-telescope-lsp', { clear = true }),
  callback = function(event)
    local ok, builtin = pcall(require, 'telescope.builtin')
    if not ok then return end
    local buf = event.buf
    map('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
    map('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
    map('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
    map('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
    map('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
    map('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
  end,
})

-- ── conform (format) ─────────────────────────────────────────────────────────
map('', '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })

-- ── Git ──────────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<leader>gg', function() require('neogit').open() end, { desc = 'Open Neogit' })
-- ── File tree ────────────────────────────────────────────────────────────────
map('n', '\\', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Neo-tree' })

-- ── Spectre ──────────────────────────────────────────────────────────────────
map('n', '<leader>S', function() require('spectre').toggle() end, { desc = 'Toggle Spectre (project search & replace)' })

-- ── UFO folds ────────────────────────────────────────────────────────────────
map('n', 'zR', function() require('ufo').openAllFolds() end, { desc = 'Open all folds' })
map('n', 'zM', function() require('ufo').closeAllFolds() end, { desc = 'Close all folds' })

-- ── DAP (debug) ───────────────────────────────────────────────────────────────
map('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = '[D]ebug toggle [B]reakpoint' })
map('n', '<leader>dc', function() require('dap').continue() end, { desc = '[D]ebug [C]ontinue / Start' })
map('n', '<leader>ds', function() require('dap').step_over() end, { desc = '[D]ebug [S]tep over' })
map('n', '<leader>di', function() require('dap').step_into() end, { desc = '[D]ebug Step [I]nto' })
map('n', '<leader>do', function() require('dap').step_out() end, { desc = '[D]ebug Step [O]ut' })
map('n', '<leader>du', function() require('dapui').toggle() end, { desc = '[D]ebug [U]I toggle' })
map('n', '<leader>dq', function() require('dap').terminate() end, { desc = '[D]ebug [Q]uit' })

-- Tmux navigation -------------------------------------------------------------
vim.keymap.set('n', '<c-h>', ':TmuxNavigateLeft<cr>', { silent = true })
vim.keymap.set('n', '<c-j>', ':TmuxNavigateDown<cr>', { silent = true })
vim.keymap.set('n', '<c-k>', ':TmuxNavigateUp<cr>', { silent = true })
vim.keymap.set('n', '<c-l>', ':TmuxNavigateRight<cr>', { silent = true })

-- Vimux -----------------------------------------------------------------------
-- Keymap to open a prompt for a command to run in a tmux pane
vim.keymap.set('n', '<leader>vp', ':VimuxPromptCommand<CR>')
-- Keymap to close the Vimux runner pane
vim.keymap.set('n', '<leader>vi', ':VimuxInspectRunner<CR>')
