-- lua/persist.lua
local M = {}
local path = vim.fn.stdpath('data') .. '/persist.json'

local function load()
  local ok, data = pcall(vim.fn.readfile, path)
  if not ok then return {} end
  return vim.json.decode(table.concat(data, '')) or {}
end

local function save(state)
  vim.fn.writefile({ vim.json.encode(state) }, path)
end

function M.get(key, default)
  return load()[key] or default
end

function M.set(key, value)
  local state = load()
  state[key] = value
  save(state)
end

return M
