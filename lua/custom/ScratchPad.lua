local M = {}

-- State storage tracking indicators
M.scratch_buf = M.scratch_buf or nil
M.scratch_win = M.scratch_win or nil
M.current_state = 'closed' -- "closed", "mini", "maximized"
M.previous_cursor = nil -- Tracks code line cursor positions

-- Hard drive file path location for permanent storage
local save_path = vim.fn.expand '~/.nvim_scratchpad.txt'

local function get_win_opts(state)
  local stats = vim.api.nvim_list_uis()[1]
  if not stats then return {} end

  if state == 'mini' then
    return {
      relative = 'editor',
      width = 30,
      height = 1,
      row = 1,
      col = stats.width - 32,
      style = 'minimal',
      border = 'rounded',
      focusable = false,
    }
  else
    local width = math.floor(stats.width * 0.75)
    local height = math.floor(stats.height * 0.75)
    return {
      relative = 'editor',
      width = width,
      height = height,
      row = math.floor((stats.height - height) / 2),
      col = math.floor((stats.width - width) / 2),
      style = 'minimal',
      border = 'rounded',
      focusable = true,
    }
  end
end

-- Helper functions to read/write files to the hard drive
local function save_to_disk(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local file = io.open(save_path, 'w')
  if file then
    for _, line in ipairs(lines) do
      file:write(line .. '\n')
    end
    file:close()
  end
end

local function load_from_disk()
  local lines = {}
  local file = io.open(save_path, 'r')
  if file then
    for line in file:lines() do
      table.insert(lines, line)
    end
    file:close()
  else
    -- Default message if the file doesn't exist yet on day one
    lines = { 'Write your persistent design notes here...' }
  end
  return lines
end

function M.toggle_scratchpad()
  -- 1. Initialize our baseline cache elements safely
  if not M.scratch_buf or not vim.api.nvim_buf_is_valid(M.scratch_buf) then
    M.scratch_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(M.scratch_buf, 'AI-Notes')
    vim.bo[M.scratch_buf].filetype = 'text'
  end

  -- 2. State Machine Transformations
  if M.current_state == 'closed' then
    M.previous_cursor = { vim.api.nvim_get_current_win(), vim.api.nvim_win_get_cursor(0) }

    -- Put buffer into Read-Only header preview mode
    vim.bo[M.scratch_buf].modifiable = true
    vim.api.nvim_buf_set_lines(M.scratch_buf, 0, -1, false, { ' 󱜙 [Floating SpaceShip] ' })
    vim.bo[M.scratch_buf].modifiable = false

    local opts = get_win_opts 'mini'
    M.scratch_win = vim.api.nvim_open_win(M.scratch_buf, false, opts)
    M.current_state = 'mini'
  elseif M.current_state == 'mini' then
    -- EXPANDING: Load the latest stored lines straight off your hard drive disk
    local saved_lines = load_from_disk()

    vim.bo[M.scratch_buf].modifiable = true
    vim.api.nvim_buf_set_lines(M.scratch_buf, 0, -1, false, saved_lines)

    local opts = get_win_opts 'maximized'
    vim.api.nvim_win_set_config(M.scratch_win, opts)
    vim.api.nvim_set_current_win(M.scratch_win)
    M.current_state = 'maximized'
  elseif M.current_state == 'maximized' then
    -- SHRINKING: Commit edits to physical storage, then swap back to mini banner
    save_to_disk(M.scratch_buf)

    vim.bo[M.scratch_buf].modifiable = true
    vim.api.nvim_buf_set_lines(M.scratch_buf, 0, -1, false, { ' 󱜙  [AI Workspace Active]' })
    vim.bo[M.scratch_buf].modifiable = false

    local opts = get_win_opts 'mini'
    vim.api.nvim_win_set_config(M.scratch_win, opts)

    if M.previous_cursor and vim.api.nvim_win_is_valid(M.previous_cursor[1]) then
      vim.api.nvim_set_current_win(M.previous_cursor[1])
      vim.api.nvim_win_set_cursor(M.previous_cursor[1], M.previous_cursor[2])
    end
    M.current_state = 'mini'
  end
end

-- Keybind Orchestrations
vim.keymap.set({ 'n', 't' }, '<leader>ff', M.toggle_scratchpad, { desc = 'Toggle [F]loating [F]ile Canvas' })

vim.keymap.set('n', '<leader>fc', function()
  if M.current_state == 'maximized' then save_to_disk(M.scratch_buf) end
  if M.scratch_win and vim.api.nvim_win_is_valid(M.scratch_win) then vim.api.nvim_win_close(M.scratch_win, true) end
  M.current_state = 'closed'
  print 'Scratchpad saved safely to disk.'
end, { desc = '[F]loating Canvas [C]lose' })

return M
