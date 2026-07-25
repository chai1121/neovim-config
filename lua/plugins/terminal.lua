return {
  {
    "akinsho/toggleterm.nvim", version = "*", cmd = "ToggleTerm",
    opts = { direction = "float", float_opts = { border = "rounded", width = function() return math.floor(vim.o.columns * 0.9) end, height = function() return math.floor(vim.o.lines * 0.8) end } },
  },
}
