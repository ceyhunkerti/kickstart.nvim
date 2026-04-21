-- =============================================================================
-- plugins/lsp.lua — mason, lspconfig, fidget, conform
-- =============================================================================

vim.pack.add {
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/neovim/nvim-lspconfig',
}

require('mason').setup {}

-- Document highlight on cursor hold
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local hl = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = hl,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = hl,
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

---@type table<string, vim.lsp.Config>
local servers = {
  elixirls = {},
  rust_analyzer = {},
  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
        workspace = {
          checkThirdParty = false,
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), { '${3rd}/luv/library', '${3rd}/busted/library' }),
        },
      })
    end,
    settings = { Lua = {} },
  },
  ruff = {},
  pyright = {},
  ts_ls = {
    -- Explicitly handle JS/TS files
    filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
    settings = {
      javascript = {
        suggest = { completeFunctionCalls = true },
        inlayHints = { includeInlayParameterNameHints = 'all' },
      },
    },
  },
}

-- 1. Setup Mason Tool Installer
local mason_ensure = vim.tbl_filter(function(n) return n ~= 'rust_analyzer' end, vim.tbl_keys(servers))
require('mason-tool-installer').setup { ensure_installed = mason_ensure }

-- 2. Setup Mason-LSPConfig to bridge Mason and Lspconfig
-- This is the "standard" way to ensure servers are configured as they are installed
require('mason-lspconfig').setup {
  handlers = {
    function(server_name)
      local server_config = servers[server_name] or {}
      -- This line replaces vim.lsp.enable and vim.lsp.config
      -- It properly registers the :LspInfo command and handles root_dir
      require('lspconfig')[server_name].setup(server_config)
    end,
  },
}

-- Conform (Formatting)
vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    if ({ c = true, cpp = true })[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' },
    python = { 'ruff_format' },
  },
}
