-- ~/.config/nvim/lua/config/options.lua

-- Numbers
vim.wo.number = true -- absolute line number on current line
vim.wo.relativenumber = true -- relative line numbers

-- Indent & tabs
vim.opt.expandtab = true -- replace tabs with spaces
vim.opt.shiftwidth = 4 -- indent size
vim.opt.tabstop = 4 -- tab width
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true -- case insensitive search
vim.opt.incsearch = true -- show matches as you type
vim.opt.hlsearch = true -- highlight matches

-- UI
vim.opt.termguicolors = true -- better colors in terminal
vim.opt.cursorline = true -- highlight current line
vim.opt.signcolumn = "yes" 
vim.opt.scrolloff = 4 -- keeps 4 lines visible above or below the cursor
vim.opt.showmode = true -- show current mode
vim.opt.wrap = false -- don’t soft-wrap long lines

-- Mouse & clipboard
vim.opt.mouse = "a" -- enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- Splits
vim.opt.splitright = true -- vertical splits open to the right
vim.opt.splitbelow = true -- horizontal splits open to the bottom

-- Files & undo
vim.opt.undofile = true -- persistent undo
vim.opt.undolevels = 2000
vim.opt.backup = false
vim.opt.writebackup = false
