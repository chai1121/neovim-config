vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  local result = vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.notify("无法下载 lazy.nvim：" .. result, vim.log.levels.ERROR)
  end
end
vim.opt.rtp:prepend(lazypath)

local lazy_ok, lazy = pcall(require, "lazy")
if lazy_ok then
  lazy.setup({ { import = "plugins" } })
else
  vim.notify("无法加载 lazy.nvim", vim.log.levels.ERROR)
end

require("config.keymaps")
require("config.lsp")
