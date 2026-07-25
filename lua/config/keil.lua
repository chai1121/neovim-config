local M = {}

-- 可按机器调整；也可在个人配置中覆盖 vim.g.keil_uv4。
local default_uv4 = "/mnt/e/Keil_v5/UV4/UV4.exe"
local last_job

local function project_file()
  local start = vim.api.nvim_buf_get_name(0)
  local found = vim.fs.find(function(name) return name:match("%.uvprojx$") ~= nil end, { path = start ~= "" and start or vim.fn.getcwd(), upward = true, limit = 1, type = "file" })
  if not found[1] then
    found = vim.fn.globpath(vim.fn.getcwd(), "**/*.uvprojx", false, true)
  end
  return found[1]
end

local function targets(path)
  local result, seen = {}, {}
  for _, line in ipairs(vim.fn.readfile(path)) do
    local target = line:match("<TargetName>%s*(.-)%s*</TargetName>")
    if target and target ~= "" and not seen[target] then
      seen[target] = true
      table.insert(result, target)
    end
  end
  return result
end

local function html_to_text(line)
  return line:gsub("<br%s*/?>", "\n"):gsub("<[^>]->", ""):gsub("&nbsp;", " "):gsub("&amp;", "&")
end

local function build_logs(root)
  local logs = vim.fn.globpath(root .. "/Objects", "*.build_log.htm", false, true)
  table.sort(logs, function(a, b) return vim.fn.getftime(a) > vim.fn.getftime(b) end)
  return logs
end

local function show_build_output(root)
  local logs = build_logs(root)
  if not logs[1] then return end

  local lines = {}
  for _, raw in ipairs(vim.fn.readfile(logs[1])) do
    for text in html_to_text(raw):gmatch("[^\n]+") do
      text = text:gsub("^%s+", ""):gsub("%s+$", "")
      if text ~= "" then table.insert(lines, text) end
    end
  end
  if #lines == 0 then table.insert(lines, "Keil 未在构建日志中写入可显示的文本。") end

  if not M.output_buf or not vim.api.nvim_buf_is_valid(M.output_buf) then
    M.output_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[M.output_buf].buftype = "nofile"
    vim.bo[M.output_buf].bufhidden = "hide"
    vim.bo[M.output_buf].swapfile = false
    vim.bo[M.output_buf].filetype = "keil-build"
  end
  vim.bo[M.output_buf].modifiable = true
  vim.api.nvim_buf_set_lines(M.output_buf, 0, -1, false, lines)
  vim.bo[M.output_buf].modifiable = false

  vim.cmd("botright 15split")
  vim.api.nvim_win_set_buf(0, M.output_buf)
  vim.api.nvim_buf_set_name(M.output_buf, "Keil Build Output")
end

local function populate_quickfix(root)
  local logs = build_logs(root)
  local items = {}
  for _, log in ipairs(logs) do
    for _, raw in ipairs(vim.fn.readfile(log)) do
      local text = html_to_text(raw):gsub("^%s+", "")
      local file, lnum, kind, message = text:match("(.-)%((%d+)%)%s*:%s*(%a+)%s*:%s*(.+)")
      if file and (kind:lower() == "error" or kind:lower() == "warning") then
        table.insert(items, { filename = vim.fs.normalize(root .. "/" .. file), lnum = tonumber(lnum), text = kind .. ": " .. message, type = kind:lower() == "error" and "E" or "W" })
      end
    end
  end
  vim.fn.setqflist({}, "r", { title = "Keil build", items = items })
  if #items > 0 then vim.cmd("copen") end
end

local function run(path, target, action)
  local uv4 = vim.g.keil_uv4 or default_uv4
  if vim.fn.executable(uv4) ~= 1 then
    vim.notify("找不到 Keil UV4：" .. uv4 .. "；请设置 vim.g.keil_uv4", vim.log.levels.ERROR)
    return
  end
  local root = vim.fs.dirname(path)
  -- UV4.exe 通过 WSL 启动时会错误地转换 /mnt/... 形式的绝对工程路径。
  -- 在工程目录中传入文件名与手动可用的命令一致。
  local project_name = vim.fn.fnamemodify(path, ":t")
  local command = table.concat({ vim.fn.shellescape(uv4), "-" .. action, vim.fn.shellescape(project_name), "-t", vim.fn.shellescape(target) }, " ")
  local Terminal = require("toggleterm.terminal").Terminal
  local terminal = Terminal:new({
    cmd = command, dir = root, direction = "float", close_on_exit = false,
    on_exit = function(_, _, exit_code)
      populate_quickfix(root)
      show_build_output(root)
      -- UV4 的 1 表示“只有警告”，仍属成功构建。
      local succeeded = exit_code < 2
      vim.notify(succeeded and ("Keil 构建完成：" .. target) or ("Keil 构建失败：" .. target), succeeded and vim.log.levels.INFO or vim.log.levels.ERROR)
    end,
  })
  last_job = { path = path, target = target, action = action }
  terminal:toggle()
  M.terminal = terminal
end

local function choose_and_run(action)
  local path = project_file()
  if not path then
    vim.notify("当前目录及上级目录中未找到 .uvprojx 工程", vim.log.levels.WARN)
    return
  end
  local list = targets(path)
  if #list == 0 then
    vim.notify("工程中未找到 Keil target", vim.log.levels.ERROR)
  elseif #list == 1 then
    run(path, list[1], action)
  else
    vim.ui.select(list, { prompt = "选择 Keil 构建 target" }, function(choice)
      if choice then run(path, choice, action) end
    end)
  end
end

function M.build()
  choose_and_run("b")
end

function M.rebuild()
  choose_and_run("r")
end

function M.repeat_last()
  if last_job then run(last_job.path, last_job.target, last_job.action) else M.build() end
end

function M.clear_terminal()
  if M.terminal and M.terminal.bufnr and vim.api.nvim_buf_is_valid(M.terminal.bufnr) then
    vim.api.nvim_buf_set_lines(M.terminal.bufnr, 0, -1, false, {})
  end
end

function M.toggle_quickfix()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end

function M.show_build_output()
  local path = project_file()
  if path then show_build_output(vim.fs.dirname(path)) end
end

return M
