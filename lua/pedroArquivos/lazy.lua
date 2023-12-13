-- Define the path for the lazy.nvim plugin
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone lazy.nvim from GitHub if it's not already present
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- Use the latest stable release
        lazypath,
    })
end

-- Add lazy.nvim path to Neovim runtimepath
vim.opt.rtp:prepend(lazypath)

-- Configure plugins using lazy.nvim setup
require("lazy").setup({
    -- LSP (Language Server Protocol) setup
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "jay-babu/mason-nvim-dap.nvim" },

            -- null-ls
            { "jose-elias-alvarez/null-ls.nvim" },
            { "jay-babu/mason-null-ls.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip", version = "2.*" },
            { "honza/vim-snippets" },
        },
    },

    -- Navigation plugins
    {'nvim-lua/plenary.nvim'},
    { "simrat39/symbols-outline.nvim" },

    -- Debugging plugins
    { "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui" },
    { "theHamsta/nvim-dap-virtual-text" },

    -- Miscellaneous plugins
    { "mbbill/undotree" },
    { "RaafatTurki/hex.nvim" },
        -- Looks plugin with color scheme
    {
        "xero/miasma.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme miasma")
        end,
    },
    {'Jorengarenar/COBOl.vim'},
    {'norcalli/nvim-colorizer.lua'},
})

