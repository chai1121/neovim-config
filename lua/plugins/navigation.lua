return {
  {
    "folke/which-key.nvim", event = "VeryLazy",
    opts = {
      delay = 300,
      icons = { mappings = false },
      spec = {
        { "<leader>f", group = "文件 / 搜索" }, { "<leader>b", group = "缓冲区" },
        { "<leader>w", group = "窗口" }, { "<leader>t", group = "终端 / 任务" },
        { "<leader>g", group = "Git" },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    opts = {
      enable_git_status = true, enable_diagnostics = false,
      default_component_configs = { icon = { folder_closed = "", folder_open = "", folder_empty = "", default = "" } },
      window = { position = "left", width = 34 },
      filesystem = { filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false } },
    },
  },
  {
    "akinsho/bufferline.nvim", version = "*", event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers", diagnostics = false, show_buffer_icons = false, show_buffer_close_icons = false,
        show_close_icon = false, separator_style = "thin",
        offsets = { { filetype = "neo-tree", text = "Files", text_align = "center" } },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
