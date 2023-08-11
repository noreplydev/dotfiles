
local set = vim.opt

set.number = true --set nubers of the columns
set.relativenumber = true --set relative numbers to the colum
set.autoindent = true --set indention
set.tabstop = 2
set.shiftwidth = 2 
set.softtabstop = 2 
set.smarttab = true
set.expandtab = true --converts tabs to spaces
set.keymodel = 'startsel' --enable key type that allow select with shift and arrows
set.cursorline = true --highlight actual line
set.mouse = 'a' --use the mouse as normal

--NORMAL mode
vim.keymap.set('n', '<C-i>', ':PackerSync <CR>')

--INSERT mode
vim.keymap.set('i', 'jj', '<ESC>')

--VISUAL mode
vim.keymap.set('x', 'jj', '<ESC>')
vim.keymap.set('x', 'i', 'I')

--MIXED modes
vim.keymap.set({'n', 'i', 'x'}, '<C-b>', '<ESC> :NvimTreeToggle <CR>')

-- CUSTOMIZATION OF APPARENCE

-- set termguicolors to enable highlight groups
set.termguicolors = true

-- using smuri colorscheme
vim.cmd 'colorscheme smuri'

--INSTALLING THE PLUGINS
require('packer').startup(function(use)

  --Package manager for auto-updated
  use 'wbthomason/packer.nvim'
 
  --Tree plugin
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  --Colors preview
  use 'norcalli/nvim-colorizer.lua'

  --Syntax highlight  [:TSInstall <language-name>]
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  --Autopairs 
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
end)

-- SETTING UP THE PLUGINS
require('nvim-tree').setup()
require('colorizer').setup()

local statusline = require('statusline') -- automatically search on modules folder
statusline.setUp()

