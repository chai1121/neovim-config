return {
  {
    "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    opts = { ensure_installed = { "markdown", "markdown_inline" }, highlight = { enable = true } },
    config = function(_, opts)
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then configs.setup(opts) end
    end,
  },
  {
    "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" },
    opts = { defaults = { layout_strategy = "horizontal", sorting_strategy = "ascending", layout_config = { prompt_position = "top", preview_width = 0.55 } } },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown" }, dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "切换 Markdown 预览" } },
    opts = { heading = { sign = false }, code = { sign = false } },
  },
}
