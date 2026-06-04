return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'astrotheme',
        component_separators = { left = '│', right = '│' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'neo-tree', 'toggleterm' },
        },
      },
      sections = {
        lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },

        -- Center/Right UI sections
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },

        -- The Far Right Block (Where the improvements live)
        lualine_z = {
          -- 1. Custom Calendar Date Component
          {
            'datetime',
            style = '%Y-%m-%d', -- Formats as YYYY-MM-DD
            icon = '',
            color = { fg = '#000000' },
          },
          -- 2. Enhanced Clock Component (Replaces the Heirline logic)
          {
            'datetime',
            style = '%I:%M %p', -- %I:%M %p gives "12-hour formatting + AM/PM"
            icon = '', -- Your custom NerdFont clock icon
            color = { fg = '#000000', gui = 'bold' }, -- Matches Heirline's green/bold style
            separator = { right = '' },
            left_padding = 2,
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
