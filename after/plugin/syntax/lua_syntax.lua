-- Set up lspconfig.

local lspconfig = require('lspconfig') 
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
lspconfig.lua_ls.setup {
    capabilities = capabilities
}

