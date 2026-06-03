-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {

  {
    'Exafunction/windsurf.vim', -- Note the .vim extension
    lazy = false, -- Force it to load immediately for setup
    config = function()
      -- This sets the keybind to accept suggestions with Ctrl+g
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end,
  },

  {
    'stevearc/resession.nvim',
    lazy = false, -- Load on startup so it can handle auto-restoring
    config = function()
      local resession = require 'resession'
      resession.setup {
        -- This matches AstroNvim's default of ignoring git commits/rebase files
        buf_filter = function(bufnr)
          local buftype = vim.bo[bufnr].buftype
          if buftype == 'help' or buftype == 'nofile' then return false end -- <-- This was the missing "end" causing the error!

          local filetype = vim.bo[bufnr].filetype
          if filetype == 'gitcommit' or filetype == 'gitrebase' then return false end
          return true
        end,
      }
    end,
  },
  -- 1. The AstroVim Theme
  {
    'AstroNvim/astrotheme',
    lazy = false, -- Load it immediately
    priority = 1000, -- Load it before everything else
    config = function()
      require('astrotheme').setup {
        palette = 'astrodark', -- The exact default look of AstroVim
      }
      vim.cmd 'colorscheme astrotheme'
    end,
  },

  -- 2. Bufferline (The browser-like tabs at the top)
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        always_show_bufferline = true,
      },
    },
  },
}
