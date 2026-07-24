-- 基础编辑体验 ---------------------------------------------------------------
vim.g.mapleader = " "

-- 插件管理与模糊搜索。首次启动时会用 git 下载 lazy.nvim 和 Telescope。
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
  lazy.setup({
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "模糊查找文件" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "全局搜索内容" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "搜索已打开文件" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "搜索帮助" },
      },
      opts = {
        defaults = {
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top", preview_width = 0.55 },
        },
      },
    },
  })
end

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

-- 传统 Keil 工程通常是 C/C++；强制打开内置语法高亮。
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- 常用按键。定义/引用/重命名仅在 clangd 已运行时可用。
local map = vim.keymap.set
map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "文件浏览器" })
map("n", "-", "<cmd>Explore<cr>", { desc = "文件浏览器" })
map("n", "gd", vim.lsp.buf.definition, { desc = "跳到定义" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "跳到声明" })
map("n", "gr", vim.lsp.buf.references, { desc = "查找引用" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "跳到实现" })
map("n", "K", vim.lsp.buf.hover, { desc = "显示符号说明" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "重命名符号" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "代码操作" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "上一条诊断" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "下一条诊断" })

-- clangd：它既提供补全，也提供跨文件跳转、引用查找和诊断。
-- 配置只在系统中实际安装 clangd 时启用，其他文件类型不受影响。
local clangd = vim.fn.exepath("clangd")
if clangd ~= "" then
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp", "cuda", "h", "hpp" },
    callback = function(args)
      local clients = (vim.lsp.get_clients or vim.lsp.get_active_clients)({
        bufnr = args.buf,
        name = "clangd",
      })
      if clients[1] then
        return
      end
      local root = vim.fn.getcwd()
      if vim.fs and vim.fs.root then
        root = vim.fs.root(args.buf, {
          "compile_commands.json", "compile_flags.txt", ".clangd", ".git",
        }) or root
      end
      vim.lsp.start({
        name = "clangd",
        cmd = { clangd, "--background-index", "--clang-tidy" },
        root_dir = root,
        capabilities = capabilities,
      })
    end,
  })
end
