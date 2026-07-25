local clangd = vim.fn.exepath("clangd")
if clangd == "" then return end

local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda", "h", "hpp" },
  callback = function(args)
    local clients = (vim.lsp.get_clients or vim.lsp.get_active_clients)({ bufnr = args.buf, name = "clangd" })
    if clients[1] then return end
    local root = vim.fn.getcwd()
    if vim.fs and vim.fs.root then
      root = vim.fs.root(args.buf, { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" }) or root
    end
    vim.lsp.start({
      name = "clangd", cmd = { clangd, "--background-index", "--clang-tidy" },
      root_dir = root, capabilities = capabilities,
    })
  end,
})
