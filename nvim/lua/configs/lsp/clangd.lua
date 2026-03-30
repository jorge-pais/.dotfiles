local nvlsp = require "nvchad.configs.lspconfig"

-- clangd configuration using new API
vim.lsp.config["clangd"] = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--query-driver=/usr/bin/clang++"
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  root_markers = {
    'compile_commands.json',
    '.clangd',
    '.git',
  },
}
