-- =============================================================================
-- plugins/ui.lua — colorscheme, statusline, indent guides, devicons, which-key
-- =============================================================================

-- ── gruvbox-material ─────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/sainnhe/gruvbox-material' }
vim.g.gruvbox_material_enable_italic = 0
vim.g.gruvbox_material_disable_italic_comment = 1
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_treesitter = 1
vim.opt.termguicolors = true
vim.cmd.colorscheme 'gruvbox-material'
vim.api.nvim_set_hl(0, 'TSString', { link = 'String' })
vim.api.nvim_set_hl(0, 'String', { fg = '#9ccc65' })

-- Override indent-blankline highlight groups after the colorscheme loads
vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#2a2a2a' })
vim.api.nvim_set_hl(0, 'IblScope', { fg = '#404040' })

-- ── indent-blankline ─────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/lukas-reineke/indent-blankline.nvim' }
require('ibl').setup {
  indent = { char = '▏' },
  scope = { enabled = false },
}

-- ── nvim-web-devicons ────────────────────────────────────────────────────────
if vim.g.have_nerd_font then
  vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' }
  require('nvim-web-devicons').setup {}
end

-- ── which-key ────────────────────────────────────────────────────────────────
vim.pack.add { 'https://github.com/folke/which-key.nvim' }
require('which-key').setup {
  delay = 1000,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { '<leader>d', group = '[D]ebug' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

-- ── lualine ────────────────────────────────────────────────────────────────
vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
}

require('lualine').setup {
  options = {
    icons_enabled = vim.g.have_nerd_font,
    theme = 'gruvbox-material',
    section_separators = '', -- removes the > arrows
    component_separators = '', -- removes the inner separators too
  },
  sections = {
    lualine_c = { { 'filename', path = 1 } }, -- 1 = relative path
    lualine_x = { 'diagnostics', 'filetype' },
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        max_length = vim.o.columns, -- use full width
      },
    },
    lualine_z = {},
  },
}

vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/folke/snacks.nvim',
}
require('snacks').setup {
  picker = {
    layout = 'ivy',
    auto_close = false,
  },
}
require('neo-tree').setup {
  hide_root_node = true,
  enable_git_status = false,
  filesystem = {
    follow_current_file = { enabled = true, leave_dirs_open = true },
    filtered_items = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = false,
      always_show_by_pattern = { '.env*' },
      hide_by_name = { 'node_modules', 'venv', '.venv' },
      never_show_by_pattern = { '*.pyc', '*.pyo', '*/__pycache__' },
      hide_root_node = true,
    },
    components = {
      -- This specifically hides the path part of the root node
      name = function(config, node, state)
        if node.type == 'root' then
          return {
            text = vim.fn.fnamemodify(node.path, ':t'), -- Shows only the folder name
            highlight = 'NeoTreeRootName',
          }
        end
        return require('neo-tree.sources.filesystem.components').name(config, node, state)
      end,
    },
  },
  window = {
    mappings = {
      ['Y'] = function(state)
        local node = state.tree:get_node()
        if not node or not node.id then
          vim.notify('No node selected.', vim.log.levels.WARN)
          return
        end

        if vim.fn.has 'clipboard' == 0 then
          vim.notify('System clipboard is not available.', vim.log.levels.ERROR)
          return
        end

        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local choices = {
          { label = 'Absolute path', value = filepath },
          { label = 'Path relative to CWD', value = modify(filepath, ':.') },
          { label = 'Path relative to HOME', value = modify(filepath, ':~') },
          { label = 'Filename', value = filename },
          { label = 'Filename without extension', value = modify(filename, ':r') },
          { label = 'Extension of the filename', value = modify(filename, ':e') },
        }

        require('snacks').picker.select(choices, {
          prompt = 'Choose to copy to clipboard:',
          format_item = function(item) return string.format('%-30s %s', item.label, item.value) end,
        }, function(choice)
          if not choice then
            vim.notify('Copy cancelled.', vim.log.levels.INFO)
            return
          end

          vim.fn.setreg('+', choice.value)
          vim.notify('Copied to clipboard: ' .. choice.value)
        end)
      end,
    },
  },
}

vim.pack.add {
  { src = 'https://github.com/brenoprata10/nvim-highlight-colors', opt = false },
}

require('nvim-highlight-colors').setup {
  render = 'background', -- or 'foreground'
}

-- require('vim._core.ui2').enable {}
