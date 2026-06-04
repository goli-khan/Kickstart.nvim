return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' }, -- Triggers right before saving the file
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function() require('conform').format { async = true, lsp_format = 'fallback' } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    -- 1. Enable format_on_save globally
    format_on_save = function(bufnr)
      -- Optional: Disable autoformat for languages without strict style guides
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then return end

      return {
        timeout_ms = 500,
        lsp_format = 'fallback', -- Uses prettier/stylua first; drops back to LSP if missing
      }
    end,
    -- 2. Define which formatters execute on specific filetypes
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Web development targets (uses prettier to handle your web layouts cleanly!)
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
