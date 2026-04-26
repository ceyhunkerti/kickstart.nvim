-- lua/utils/ui.lua
-- UI-related utility functions

local M = {}

--- List of buffer types/filetypes to preserve across all buffer operations
local preserve_filetypes = {
  'neo-tree',
  'NvimTree',
  'netrw',
  'qf', -- quickfix list
  'help',
  'terminal',
}

--- Close all buffers except the current one, preserving special buffers
--- Special buffers like neo-tree, help, quickfix, etc. are not closed
function M.close_other_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    -- Skip current buffer
    if buf == current_buf then goto continue end

    -- Check if buffer is valid and loaded
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then goto continue end

    -- Get buffer filetype
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

    -- Check if this filetype should be preserved
    for _, preserve_ft in ipairs(preserve_filetypes) do
      if filetype == preserve_ft then goto continue end
    end

    -- Close the buffer
    vim.api.nvim_buf_delete(buf, { force = false })

    ::continue::
  end
end

--- Close all buffers, preserving special buffers
--- Special buffers like neo-tree, help, quickfix, etc. are not closed
function M.close_all_buffers()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    -- Check if buffer is valid and loaded
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then goto continue end

    -- Get buffer filetype
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

    -- Check if this filetype should be preserved
    for _, preserve_ft in ipairs(preserve_filetypes) do
      if filetype == preserve_ft then goto continue end
    end

    -- Close the buffer
    vim.api.nvim_buf_delete(buf, { force = false })

    ::continue::
  end
end

return M
