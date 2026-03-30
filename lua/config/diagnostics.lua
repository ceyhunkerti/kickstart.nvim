-- =============================================================================
-- config/diagnostics.lua — vim.diagnostic configuration
-- =============================================================================

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort    = true,
  float            = { border = 'rounded', source = 'if_many' },
  underline        = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text     = true,   -- inline text at end of line
  virtual_lines    = false,  -- underneath-line virtual lines (flip if preferred)
  jump             = { float = true }, -- auto-open float when jumping with [d/]d
}
