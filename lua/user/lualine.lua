-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
-- use default Xterm colors since termguicolors = false
local colors = {
  bg            = '#000000',
  fg            = '#c0c0c0',
  black         = '#000000',
  dark_red      = '#800000',
  dark_green    = '#008000',
  dark_yellow   = '#808000',
  dark_blue     = '#000080',
  dark_magenta  = '#800080',
  dark_cyan     = '#008080',
  gray          = '#c0c0c0',
  dark_gray     = '#808080',
  red           = '#ff0000',
  green         = '#00ff00',
  yellow        = '#ffff00',
  blue          = '#0000ff',
  magenta       = '#ff00ff',
  cyan          = '#00ffff',
  white         = '#ffffff',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg } },
      inactive = { c = { fg = colors.fg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  -- mode component
  'mode',
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n      = colors.dark_cyan,
      i      = colors.white,
      v      = colors.gray,
      [''] = colors.gray,
      V      = colors.gray,
      c      = colors.magenta,
      no     = colors.red,
      s      = colors.dark_yellow,
      S      = colors.dark_yellow,
      [''] = colors.dark_yellow,
      ic     = colors.yellow,
      R      = colors.dark_yellow,
      Rv     = colors.dark_yellow,
      cv     = colors.red,
      ce     = colors.red,
      r      = colors.cyan,
      rm     = colors.cyan,
      ['r?'] = colors.cyan,
      ['!']  = colors.red,
      t      = colors.red,
    }
    return { fg = colors.black, bg = mode_color[vim.fn.mode()] }
  end,
  padding = { left = 1, right = 1 },
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.white, gui = 'bold' },
}

ins_left {
  'branch',
  icon = '',
  color = { fg = colors.magenta, gui = 'bold' },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
  function()
    return '%='
  end,
}

ins_left {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '柳', removed = ' ' },
  diff_color = {
    added    = { fg = colors.green },
    modified = { fg = colors.dark_yellow },
    removed  = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn  = { fg = colors.yellow },
    color_info  = { fg = colors.white },
  },
}

-- Add components to right sections
ins_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.dark_gray, gui = 'bold' },
}

ins_right {
  'o:encoding', -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.dark_gray, gui = 'bold' },
}

ins_right {
  -- filesize component
  'filesize',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.dark_gray, gui = 'bold' },
}

ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

ins_right { 'location', color = { fg = colors.fg, gui = 'bold' } }


--ins_right {
--  function()
--    return '▊'
--  end,
--  color = { fg = colors.blue },
--  padding = { left = 1 },
--}

-- Now don't forget to initialize lualine
lualine.setup(config)
