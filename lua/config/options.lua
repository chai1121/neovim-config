local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 300
opt.completeopt = { "menuone", "noselect" }
opt.termguicolors = true
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")
