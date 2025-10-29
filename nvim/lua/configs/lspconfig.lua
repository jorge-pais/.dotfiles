-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- EXAMPLE
-- local servers = { "html", "cssls", "clangd", "lemminx", "bashls", "docker-language-server" }
local servers = { "html", "cssls", "clangd", "lemminx" }
local nvlsp = require "nvchad.configs.lspconfig"

vim.lsp.enable(servers)

-- lsps with default config using the new API
for _, lsp in ipairs(servers) do
  -- lsp_config.server(lsp, {
  vim.lsp.config[lsp] = {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

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
}
