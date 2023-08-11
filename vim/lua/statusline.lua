
-- show global statusline instead of splitting
vim.opt.laststatus=3

-- Create autocmd group
local statusline_group = vim.api.nvim_create_augroup('custom_statusline', { clear = true })

local modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL",
  ["v"] = "VISUAL",
  ["V"] = "VISUAL LINE",
  [""] = "VISUAL BLOCK",
  ["s"] = "SELECT",
  ["S"] = "SELECT LINE",
  [""] = "SELECT BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rv"] = "VISUAL REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "VIM EX",
  ["ce"] = "EX",
  ["r"] = "PROMPT",
  ["rm"] = "MOAR",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

-- highlight colors
local api = vim.api

api.nvim_set_hl(0, 'defaultColor', { bg='#1f212b', fg='#afafaf' })

api.nvim_set_hl(0, 'gitBranchColor', { bg='#1f212b', fg='#484E5E' })
api.nvim_set_hl(0, 'packageColor', { bg='#1f212b', fg='#4558d3' })
api.nvim_set_hl(0, 'positionColor', { bg='#262930', fg='#53d36b'})

api.nvim_set_hl(0, 'normalColor', { bg='#555555', fg='#dfdfdf' })
api.nvim_set_hl(0, 'insertColor', { bg='#4558d3', fg='#dfdfdf' })
api.nvim_set_hl(0, 'visualColor', { bg='#e2a554', fg='#1f212b' })
api.nvim_set_hl(0, 'replaceColor', { bg='#54dd95', fg='#1f212b' })
api.nvim_set_hl(0, 'commandColor', { bg='#dfdfdf', fg='#1f212b'})

-- statusline skew highlights
api.nvim_set_hl(0, 'normalSkewColor', { bg='#555555', fg='#1f212b' })
api.nvim_set_hl(0, 'insertSkewColor', { bg='#4558d3', fg='#1f212b' })
api.nvim_set_hl(0, 'visualSkewColor', { bg='#e2a554', fg='#1f212b' })
api.nvim_set_hl(0, 'replaceSkewColor', { bg='#54dd95', fg='#1f212b' })
api.nvim_set_hl(0, 'commandSkewColor', { bg='#dfdfdf', fg='#1f212b'})

-- get the actual mode color
local function getColor()

  local mode = api.nvim_get_mode().mode

  -- normal mode by default
  local color = '%#normalColor#'
  
  if(mode == 'i') then -- insert
    color = '%#insertColor#'
  elseif(mode == 'v') then -- visual
    color = '%#visualColor#'
  elseif(mode == 'R') then -- replace
    color = '%#replaceColor#'
  elseif(mode == 't' or mode == 'c') then -- terminal or command 
    color = '%#commandColor#'
  end 

  return color
end

local function skew() 
  local mode = api.nvim_get_mode().mode

  local color = '%#normalSkewColor#'

  if(mode == 'i') then -- insert
    color = '%#insertSkewColor#'
  elseif(mode == 'v') then -- visual
    color = '%#visualSkewColor#'
  elseif(mode == 'R') then -- replace
    color = '%#replaceSkewColor#'
  elseif(mode == 't' or mode == 'c') then -- terminal or command 
    color = '%#commandSkewColor#'
  end 

  return color .. ' %*'  
end

-- get and set the mode text
local function getMode() 
  local current_mode = api.nvim_get_mode().mode
  local mode = string.format(" %s ", modes[current_mode]):upper()
  return mode .. skew()
end

-- get the current git branch
local function getBranch()
  local branch = vim.fn.system('git branch --show-current')
  
  return '%#gitBranchColor#  ' .. string.sub(branch, 0, -2) .. ' %#defaultColor#'
end

local function getOffset()
  --we divide the branch by 2 and sum 4 spaces because < > & <./>'
  local branch = string.sub(
     vim.fn.system('git branch --show-current'),
     0, 
     -2
  )  

  local length = string.len(branch)
  local offCount =  math.floor(length/2)
  
  local offset ='  '
  for i=0, offCount, 1 do
    offset = offset .. '⠀'
  end

  return offset
end

-- get the current filename
local function getFile()
  local file = table.concat{
    '%=', -- center
    '%#defaultColor#', --highlight
    '%#packageColor# %*', 
    '%#defaultColor#%t', --filename
    getOffset()
  }
  return file
end

local function getPosition()
  return ('%=%#positionColor#  %p%% ')
end

local function setStatusline()
  vim.o.statusline = table.concat{
    getColor(), 
    getMode(),
    getBranch(), 
    getFile(), 
    getPosition()
  }
end

--set up the change mode handler
local function setUp()
  vim.api.nvim_create_autocmd({ 'VimEnter', 'ModeChanged' }, {
    group = statusline_group,
    pattern = '*', 
    callback = setStatusline
  })
end

local statusline = {}
statusline.setUp = setUp

return statusline

