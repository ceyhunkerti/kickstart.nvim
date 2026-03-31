-- =============================================================================
-- plugins/tools.lua — oil, spectre, csvview, render-markdown, auto-save,
--                     todo-comments, supermaven, neo-tree
-- Keymaps: config/keymaps.lua (\, <leader>S)
-- =============================================================================

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require('oil').setup {
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = false,
}

vim.pack.add { 'https://github.com/nvim-pack/nvim-spectre' }
require('spectre').setup {}

vim.pack.add { 'https://github.com/hat0uma/csvview.nvim' }
require('csvview').setup {
  parser = { comments = { '#', '//' } },
  keymaps = {
    textobject_field_inner = { 'if', mode = { 'o', 'x' } },
    textobject_field_outer = { 'af', mode = { 'o', 'x' } },
    jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
    jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
    jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
    jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
  },
}

vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }
require('render-markdown').setup {}

vim.pack.add { 'https://github.com/okuuva/auto-save.nvim' }
require('auto-save').setup {
  debounce_delay = 2000,
  condition = function(buf) return vim.bo[buf].filetype ~= 'oil' end,
}

vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

vim.pack.add { 'https://github.com/supermaven-inc/supermaven-nvim' }
require('supermaven-nvim').setup {
  keymaps = {
    accept_suggestion = '<M-a>',
  },
}

vim.pack.add {
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
}
require('neo-tree').setup {
  filesystem = {
    follow_current_file = { enabled = true, leave_dirs_open = true },
    filtered_items = {
      visible =false,
      hide_dotfiles = true,
      hide_gitignored = false,
      always_show_by_pattern = { '.env*' },
      hide_by_name = { 'node_modules', 'venv', '.venv' },
    },
  },
  default_component_configs = {
    icon = {
      provider = function(icon, node)
        if node.type ~= 'file' and node.type ~= 'terminal' then return end
        local ok, devicons = pcall(require, 'nvim-web-devicons')
        if not ok then return end
        local name = node.type == 'terminal' and 'terminal' or node.name
        if name:match '^docker%-compose.*%.ya?ml$' then
          name = 'docker-compose.yml'
        elseif name:match '^%.env' then
          name = '.env'
        elseif name:match '^Dockerfile' then
          name = 'Dockerfile'
        end
        local text, hl = devicons.get_icon(name)
        icon.text = text or icon.text
        icon.highlight = hl or icon.highlight
      end,
    },
  },
}

vim.pack.add { 'https://github.com/christoomey/vim-tmux-navigator' }
-- No specific .setup{} is required for this plugin,
-- but we define the keys to ensure they match tmux
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add { 'https://github.com/preservim/vimux' }
