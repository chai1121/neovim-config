local M = {}
local terminal

local function git_root()
  local file = vim.api.nvim_buf_get_name(0)
  local directory = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  local result = vim.fn.systemlist({ "git", "-C", directory, "rev-parse", "--show-toplevel" })

  if vim.v.shell_error ~= 0 then
    vim.notify("当前文件不在 Git 仓库中", vim.log.levels.WARN)
    return nil
  end

  return result[1]
end

function M.toggle()
  local root = git_root()
  if not root then return end

  if not terminal then
    terminal = require("toggleterm.terminal").Terminal:new({
      cmd = "lazygit",
      direction = "float",
      hidden = true,
    })
  end

  terminal.dir = root
  terminal:toggle()
end

return M
