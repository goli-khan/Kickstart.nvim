-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>dr', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.keymap.set('n', '<leader>T', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })
-- vim.keymap.set('t', '<leader>T', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- Remap jk to escape in normal mode
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'jk', '<Esc>', { noremap = true, silent = true })

-- Map Shift + Enter to Escape in Normal mode
vim.api.nvim_set_keymap(
  'i', -- Insert mode
  '<C-CR>', -- Keybinding: Ctrl + Enter
  '<Esc>o', -- Action: Exit insert mode and create a new line below
  { noremap = true, silent = true } -- Options: No recursive mapping, silent execution
)
vim.opt.clipboard = 'unnamedplus'

vim.keymap.set('n', '\\', '<cmd>vsplit<cr>', { silent = true, desc = 'Split Window Vertically' })

vim.keymap.set('n', '|', '<cmd>split<cr>', { silent = true, desc = 'Split Window Horizontally' })

-- folding powered by treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter#folding
-- look for foldenable: https://github.com/neovim/neovim/blob/master/src/nvim/options.lua
-- Vim cheatsheet, look for folds keys: https://devhints.io/vim
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true -- if this option is true and fold method option is other than normal, every time a document is opened everything will be folded.
-- Safe Keymaps: Explicitly passing 'expr = false' prevents the v0.10 native clash

vim.keymap.set('n', 'zO', function() require('ufo').openAllFolds() end, { desc = 'Open all folds', remap = false, expr = false })
vim.keymap.set('n', 'zC', function() require('ufo').closeAllFolds() end, { desc = 'Close all folds', remap = false, expr = false })

-- AstroVim Buffer Navigation Mappings

-- 1. Press <leader>bb to pick a buffer via assigned letters
vim.keymap.set('n', '<leader>bb', '<cmd>BufferLinePick<cr>', { silent = true, desc = 'Pick Buffer' })

-- 2. Press <leader>bd to pick a buffer and close it instantly
vim.keymap.set('n', '<leader>bd', '<cmd>BufferLinePickClose<cr>', { silent = true, desc = 'Pick Buffer to Close' })

-- 3. Cycle through tabs easily using Shift+H and Shift+L (Just like AstroVim)
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<cr>', { silent = true, desc = 'Next Buffer' })
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<cr>', { silent = true, desc = 'Previous Buffer' })

-- Save the current file with <leader>w
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { silent = true, desc = 'Save File' })

-- Close the current buffer with <leader>c
vim.keymap.set('n', '<leader>c', '<cmd>bdelete<cr>', { silent = true, desc = 'Close Buffer' })

-- Smart Close: Closes a split window, or quits Neovim if it's the last window
vim.keymap.set('n', '<leader>q', function()
  -- Get a list of all valid windows in the current tabpage
  local wins = vim.api.nvim_tabpage_list_wins(0)

  -- Filter out floating windows (like which-key, notify popups, or LSP docs)
  local normal_wins = {}
  for _, win in ipairs(wins) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == '' then table.insert(normal_wins, win) end
  end

  -- If more than one normal window is open, just close the current split
  if #normal_wins > 1 then
    vim.cmd 'close'
  else
    -- If it's the last window, write changes and quit all safely
    vim.cmd 'xa'
  end
end, { silent = true, desc = 'Close Split / Quit Neovim' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
