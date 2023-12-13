local lsp = require('lsp-zero')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Function to load language-specific configurations
local function load_language_config(filetype)
    local syntax_config_path = "pedroArquivos.syntax." .. filetype
    local status_ok, lang_config = pcall(require, syntax_config_path)
    if status_ok then
        lang_config.setup()
    end
end

-- Fix Undefined global 'vim'
lsp.nvim_workspace()

lsp.on_attach(function(client, bufnr)
    -- Existing keymaps and other configurations

    -- Load language-specific configurations
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    load_language_config(filetype)
end)

-- Mason setup
require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        lsp.default_setup,
    }
})

-- Set the global LSP configuration
lsp.setup({
    capabilities = capabilities,
    on_attach = on_attach_function -- If you have a specific on_attach function defined
})

