-- =============================================================================
-- plugins/lsp.lua — Language Server Protocol
--   mason                  — installer for LSP servers, formatters, linters
--   mason-lspconfig        — bridges mason ↔ nvim-lspconfig names
--   mason-tool-installer   — ensures specific tools are present
--   nvim-lspconfig         — configures and enables each language server
--   fidget                 — LSP progress notifications
--   conform                — formatting (format-on-save)
-- =============================================================================

vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/neovim/nvim-lspconfig',
})

require('mason').setup {}
require('fidget').setup {}

-- ── Per-buffer LSP keymaps ────────────────────────────────────────────────────
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local function map(keys, func, desc, mode)
      vim.keymap.set(mode or 'n', keys, func,
        { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn',  vim.lsp.buf.rename,      '[R]e[n]ame')
    map('gra',  vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD',  vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Inlay hints toggle
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
        )
      end, '[T]oggle Inlay [H]ints')
    end

    -- Document highlight on cursor hold
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local hl = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf, group = hl,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf, group = hl,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(e)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e.buf }
        end,
      })
    end
  end,
})

-- ── Server definitions ───────────────────────────────────────────────────────
-- rust_analyzer is excluded from Mason (managed by `rustup component add rust-analyzer`)
-- codelldb (debug adapter) is installed via Mason in plugins/dap.lua
---@type table<string, vim.lsp.Config>
local servers = {
  elixirls      = {},
  stylua        = {},  -- Lua formatter (also used by conform)
  rust_analyzer = {},  -- managed by rustup, NOT Mason
  lua_ls        = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config'
          and (vim.uv.fs_stat(path .. '/.luarc.json')
            or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
        then
          return
        end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force',
        client.config.settings.Lua, {
          runtime   = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend('force',
              vim.api.nvim_get_runtime_file('', true),
              { '${3rd}/luv/library', '${3rd}/busted/library' }
            ),
          },
        })
    end,
    settings = { Lua = {} },
  },
}

-- Install everything except rust_analyzer through Mason
local mason_ensure = vim.tbl_filter(
  function(n) return n ~= 'rust_analyzer' end,
  vim.tbl_keys(servers)
)
require('mason-tool-installer').setup { ensure_installed = mason_ensure }

-- Enable each server via the new vim.lsp API (Neovim 0.11+)
for name, config in pairs(servers) do
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end

-- ── conform (format on save) ─────────────────────────────────────────────────
vim.pack.add({ 'https://github.com/stevearc/conform.nvim' })
require('conform').setup {
  notify_on_error = false,
  format_on_save  = function(bufnr)
    local disable = { c = true, cpp = true }
    if disable[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    lua  = { 'stylua' },
    rust = { 'rustfmt' },
  },
}

vim.keymap.set('', '<leader>f', function()
  require('conform').format { async = true, lsp_format = 'fallback' }
end, { desc = '[F]ormat buffer' })
