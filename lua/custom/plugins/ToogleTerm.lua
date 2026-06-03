local M = {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
}

function M.config()
  local wk = require 'which-key'

  require('toggleterm').setup {
    size = 15,
    open_mapping = nil, -- we handle this manually via which-key
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_insert = true,
    insert_go_back = true,
    persist_size = true,
    direction = 'horizontal', -- 'horizontal' | 'vertical' | 'float' | 'tab'
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      winblend = 0,
    },
  }

  -- Toggle function that opens AND closes with same key
  local function toggle_term()
    local terms = require 'toggleterm.terminal'
    vim.cmd 'ToggleTerm'
  end

  -- Keymaps
  wk.add {
    { '<leader>t', group = 'Terminal' },
    { '<leader>tt', '<cmd>ToggleTerm<CR>', desc = 'Toggle Terminal' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', desc = 'Float Terminal' },
    { '<leader>tv', '<cmd>ToggleTerm direction=vertical size=50<CR>', desc = 'Vertical Terminal' },
    { '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>', desc = 'Horizontal Terminal' },
  }

  -- Leader+Shift+T specifically
  vim.keymap.set('n', '<leader>T', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal', noremap = true, silent = true })

  -- When inside the terminal, use same key to close/hide it
  -- and also ESC to go to normal mode without closing
  function _G.set_terminal_keymaps()
    local opts = { buffer = 0, noremap = true, silent = true }
    vim.keymap.set('t', '<leader>T', '<cmd>ToggleTerm<CR>', opts) -- same key closes it
    vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts) -- ESC = normal mode
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts) -- navigate left
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts) -- navigate down
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts) -- navigate up
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts) -- navigate right
  end

  -- Auto apply terminal keymaps when a terminal opens
  vim.api.nvim_create_autocmd('TermOpen', {
    pattern = 'term://*toggleterm#*',
    callback = function() _G.set_terminal_keymaps() end,
  })
end

return M
