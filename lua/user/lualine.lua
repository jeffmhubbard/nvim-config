-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg        = '#1d2021',
  fg        = '#d5d5d5',
  black     = '#383c3e',
  red       = '#d72638',
  green     = '#88b92d',
  orange    = '#eb8413',
  blue      = '#1e8bac',
  magenta   = '#be4264',
  cyan      = '#1ba595',
  gray      = '#dddddd',
  dark_gray = '#53585b',
  yellow    = '#f19d1a',
  white     = '#e5e5e5',
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
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
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
      n      = colors.cyan,
      i      = colors.white,
      v      = colors.gray,
      [''] = colors.gray,
      V      = colors.gray,
      c      = colors.magenta,
      no     = colors.red,
      s      = colors.orange,
      S      = colors.orange,
      [''] = colors.orange,
      ic     = colors.yellow,
      R      = colors.orange,
      Rv     = colors.orange,
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
    modified = { fg = colors.orange },
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
