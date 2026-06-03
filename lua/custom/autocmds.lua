-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- start
--
--
local resession_group = vim.api.nvim_create_augroup('ResessionCustom', { clear = true })

local function save_session()
  local ok, resession = pcall(require, 'resession')
  if ok then resession.save(vim.fn.getcwd(), { dir = 'dirsession', notify = false }) end
end

-- 1. SAVE ON EXIT (shutdown-proof, replaces UILeave)
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = resession_group,
  callback = save_session,
})

-- 2. SAVE EVERY TIME YOU WRITE A FILE (safety net)
vim.api.nvim_create_autocmd('BufWritePost', {
  group = resession_group,
  callback = save_session,
})

-- 3. AUTOMATICALLY RESTORE SESSION ON STARTUP
vim.api.nvim_create_autocmd('VimEnter', {
  group = resession_group,
  nested = true,
  callback = function()
    if vim.fn.argc(-1) == 0 then
      local ok, resession = pcall(require, 'resession')
      if ok then resession.load(vim.fn.getcwd(), { dir = 'dirsession', silence_errors = true }) end
    end
  end,
})
--
--
-- end

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
