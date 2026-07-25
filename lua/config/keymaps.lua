local map = vim.keymap.set
local opts = { silent = true }

-- 文件与搜索
map("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", vim.tbl_extend("force", opts, { desc = "查找文件" }))
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", vim.tbl_extend("force", opts, { desc = "查找文件" }))
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", vim.tbl_extend("force", opts, { desc = "全局搜索" }))
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", vim.tbl_extend("force", opts, { desc = "搜索缓冲区" }))
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", vim.tbl_extend("force", opts, { desc = "搜索帮助" }))
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", vim.tbl_extend("force", opts, { desc = "最近文件" }))
map("n", "<leader>fc", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, vim.tbl_extend("force", opts, { desc = "编辑 Neovim 配置" }))

-- 文件树
map("n", "<leader>e", "<cmd>Neotree toggle left reveal_force_cwd<cr>", vim.tbl_extend("force", opts, { desc = "切换文件树" }))
map("n", ".", "<cmd>Neotree toggle left reveal_force_cwd<cr>", vim.tbl_extend("force", opts, { desc = "切换文件树" }))
map("n", "-", "<cmd>Neotree toggle left reveal_force_cwd<cr>", vim.tbl_extend("force", opts, { desc = "切换文件树" }))

-- 缓冲区和窗口
map("n", "<leader>bb", "<cmd>Telescope buffers<cr>", vim.tbl_extend("force", opts, { desc = "切换缓冲区" }))
map("n", "<leader>bd", "<cmd>bdelete<cr>", vim.tbl_extend("force", opts, { desc = "关闭缓冲区" }))
map("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>", vim.tbl_extend("force", opts, { desc = "下一个缓冲区" }))
map("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", vim.tbl_extend("force", opts, { desc = "上一个缓冲区" }))
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", opts)
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", opts)
map("n", "<leader>wv", "<cmd>vsplit<cr>", vim.tbl_extend("force", opts, { desc = "垂直分屏" }))
map("n", "<leader>ws", "<cmd>split<cr>", vim.tbl_extend("force", opts, { desc = "水平分屏" }))
map("n", "<leader>wd", "<cmd>close<cr>", vim.tbl_extend("force", opts, { desc = "关闭窗口" }))
map("n", "<leader>wo", "<cmd>only<cr>", vim.tbl_extend("force", opts, { desc = "仅保留当前窗口" }))
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- 终端、任务与 quickfix
map("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", vim.tbl_extend("force", opts, { desc = "切换浮动终端" }))
map("n", "<leader>tb", function() require("config.keil").build() end, vim.tbl_extend("force", opts, { desc = "构建 Keil 项目" }))
map("n", "<leader>tr", function() require("config.keil").rebuild() end, vim.tbl_extend("force", opts, { desc = "重新构建 Keil 项目" }))
map("n", "<leader>tq", function() require("config.keil").toggle_quickfix() end, vim.tbl_extend("force", opts, { desc = "切换 quickfix" }))
map("n", "<leader>tc", function() require("config.keil").clear_terminal() end, vim.tbl_extend("force", opts, { desc = "清空任务终端" }))
map("n", "<leader>to", function() require("config.keil").show_build_output() end, vim.tbl_extend("force", opts, { desc = "显示构建输出" }))
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "退出终端模式" })

-- LSP 与诊断
map("n", "gd", vim.lsp.buf.definition, { desc = "跳到定义" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "跳到声明" })
map("n", "gr", vim.lsp.buf.references, { desc = "查找引用" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "跳到实现" })
map("n", "K", vim.lsp.buf.hover, { desc = "显示符号说明" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "重命名符号" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "代码操作" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "上一条诊断" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "下一条诊断" })
