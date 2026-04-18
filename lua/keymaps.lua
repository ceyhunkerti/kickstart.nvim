-- ============================================================================
-- keymaps.lua — ALL keymaps (core + plugin)
-- ==========================================================================

local map = vim.keymap.set

-- ── General ──────────────────────────────────────────────────────────────────
map('n', '<Esc>', function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd 'nohlsearch'
end, { desc = 'Close floating windows and clear search' })

-- ── File/Navigation ──────────────────────────────────────────────────────────
map({ 'n', 'i' }, '<C-\\>', '<cmd>e .<CR>', { desc = 'Open file tree' })
map('n', '\\', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Neo-tree' })

map({ 'n', 'v', 'o' }, '<C-,>', '^', { desc = 'Go to first non-blank char' })
map({ 'n', 'v', 'o' }, '<C-.>', '$', { desc = 'Go to last non-blank char' })

-- Buffer navigation
map('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
map('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
map({ 'n', 'i', 'v', 't' }, '<C-PageUp>', '<cmd>bprev<CR>', { desc = 'Previous buffer' })
map({ 'n', 'i', 'v', 't' }, '<C-PageDown>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map({ 'n', 'i' }, '<C-q>', function()
  local current = vim.api.nvim_get_current_buf()
  pcall(vim.cmd, 'bprev')
  vim.api.nvim_buf_delete(current, {})
end, { desc = 'Delete buffer' })
map('n', '<leader>tb', function() vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0 end, { desc = 'Toggle buffer tabline' })
map('n', '<leader>bo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Close other buffers' })
map('n', '<leader>ba', '<cmd>%bd<cr>', { desc = 'Close all buffers' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move to left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move to right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move to upper window' })

-- ── Editing ──────────────────────────────────────────────────────────────────
map('v', '>', '>gv', { desc = 'Indent and keep selection' })
map('v', '<', '<gv', { desc = 'Unindent and keep selection' })
map('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
map('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

map('n', '<S-w>', 'b', { desc = 'Move back a word' })
map('n', 'yw', 'yaw', { desc = 'Yank a word' })
map('n', 'cw', 'caw', { desc = 'Change a word' })
map('n', 'dw', 'daw', { desc = 'Delete a word' })

-- ── Clipboard ────────────────────────────────────────────────────────────────
map('n', '<leader>x', '"+dd', { desc = 'Cut line to clipboard' })
map('v', '<leader>x', '"+x', { desc = 'Cut selection to clipboard' })
map('n', '<leader>Y', 'ggVGy', { desc = 'Copy entire buffer' })

-- Delete without yanking
map('n', 'dx', '"_dd', { desc = 'Delete line (no yank)' })
map('v', 'dx', '"_d', { desc = 'Delete selection (no yank)' })
map('n', '<leader>D', 'gg"_dG', { desc = 'Delete entire buffer (no yank)' })

-- ── Search & Replace ────────────────────────────────────────────────────────
map('n', '<leader>r', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Replace word under cursor' })
map('v', '<leader>r', '"hy:%s/<C-r>h//gI<Left><Left><Left>', { desc = 'Replace visual selection' })
map('v', '<leader>da', function()
  vim.cmd 'normal! "vy'
  local sel = vim.fn.escape(vim.fn.getreg 'v', '/\\')
  vim.cmd('%s/' .. sel .. '//g')
end, { desc = 'Delete all occurrences of selection' })

-- ── Terminal ─────────────────────────────────────────────────────────────────
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ── LSP & Diagnostics ───────────────────────────────────────────────────────
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix' })
map('n', '<leader>e', function() vim.diagnostic.open_float(nil, { focus = false }) end, { desc = 'Show diagnostic float' })
map('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Toggle Trouble diagnostics' })
map('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Trouble workspace diagnostics' })
map('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Trouble symbols' })
map('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false<cr>', { desc = 'Trouble LSP' })
map('n', '<leader>xq', '<cmd>Trouble quickfix toggle<cr>', { desc = 'Trouble quickfix' })
-- LSP keymaps (buffer-local, on LspAttach)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('keymaps-lsp-attach', { clear = true }),
  callback = function(event)
    local function lmap(keys, func, desc) vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end
    lmap('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    lmap('gra', vim.lsp.buf.code_action, 'Code [A]ction')
    lmap('grD', vim.lsp.buf.declaration, '[D]eclaration')
    lmap('K', vim.lsp.buf.hover, 'Hover')

    vim.keymap.set({ 'n', 'x' }, 'gra', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'LSP: Code Action' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      lmap('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
    end
  end,
})

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
    map('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    map('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Document Symbols' })
    map('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Workspace Symbols' })
  end,
})

-- ── Telescope ────────────────────────────────────────────────────────────────
vim.defer_fn(function()
  local ok, builtin = pcall(require, 'telescope.builtin')
  if not ok then return end

  map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect' })
  map({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch [W]ord' })
  map('n', '<leader>sg', function() builtin.live_grep { additional_args = { '--fixed-strings' } } end, { desc = '[S]earch by [G]rep' })
  map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
  map('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  map('n', '<leader><leader>', builtin.buffers, { desc = 'Find buffers' })
  map('n', '<leader>sF', function() builtin.find_files { cwd = '/', hidden = true } end, { desc = '[S]earch [F]iles from root' })
  map('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
  map('n', '<leader>/', function() builtin.current_buffer_fuzzy_find { winblend = 10, previewer = false } end, { desc = 'Fuzzy search in buffer' })
  map(
    'n',
    '<leader>s/',
    function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
    { desc = 'Search in open files' }
  )
end, 0)

-- ── Git ──────────────────────────────────────────────────────────────────────
map('n', '<leader>gg', function() require('neogit').open() end, { desc = 'Open Neogit' })

-- ── Search & Replace (Spectre) ───────────────────────────────────────────────
map('n', '<leader>S', function() require('spectre').toggle() end, { desc = 'Toggle Spectre' })

-- ── Format ───────────────────────────────────────────────────────────────────
map('', '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })

-- ── Folding (UFO) ────────────────────────────────────────────────────────────
map('n', 'zR', function() require('ufo').openAllFolds() end, { desc = 'Open all folds' })
map('n', 'zM', function() require('ufo').closeAllFolds() end, { desc = 'Close all folds' })

-- ── Debug (DAP) ──────────────────────────────────────────────────────────────
map('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = '[D]ebug [B]reakpoint' })
map('n', '<leader>dc', function() require('dap').continue() end, { desc = '[D]ebug [C]ontinue' })
map('n', '<leader>ds', function() require('dap').step_over() end, { desc = '[D]ebug [S]tep' })
map('n', '<leader>di', function() require('dap').step_into() end, { desc = '[D]ebug Step [I]n' })
map('n', '<leader>do', function() require('dap').step_out() end, { desc = '[D]ebug Step [O]ut' })
map('n', '<leader>du', function() require('dapui').toggle() end, { desc = '[D]ebug [U]I' })
map('n', '<leader>dq', function() require('dap').terminate() end, { desc = '[D]ebug [Q]uit' })

-- ── Multi Cursor ─────────────────────────────────────────────────────────────
map('v', '<c-d>', function() require('multicursor-nvim').matchAllAddCursors() end, { desc = 'Add all matches' })
map('n', '<c-q>', function() require('multicursor-nvim').clearCursors() end, { desc = 'Clear cursors' })
