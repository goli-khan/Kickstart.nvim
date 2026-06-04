---@module 'lazy'
---@type LazySpec
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = { 'BufReadPost', 'BufNewFile' }, -- Lazy loads when opening a file
  config = function()
    -- 1. Setup the glow colors using Neovim highlight groups
    -- You can adjust these hex codes to match your setup!
    vim.api.nvim_set_hl(0, 'ActiveDivGlow', { fg = '#61afef', bold = true, bg = 'NONE' })     -- Vivid Sky Blue
    vim.api.nvim_set_hl(0, 'PassiveLines', { fg = '#3e4452', nocombine = true, bg = 'NONE' }) -- Dim Gray

    -- 2. Configure the indent-blankline engine
    require('ibl').setup {
      indent = {
        char = '│', -- Clean, seamless vertical line
        highlight = 'PassiveLines', -- Background/inactive line colors
      },
      scope = {
        enabled = true, -- Enables active context tracking via Treesitter
        char = '┃', -- Makes the active div line slightly thicker for a "glow" effect
        highlight = 'ActiveDivGlow', -- Applies our vivid color to the current scope
        show_exact_scope = false, -- Change to true if you only want the exact wrapper to light up
      },
    }
  end,
}
