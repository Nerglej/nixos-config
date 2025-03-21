return {
    { 'hrsh7th/cmp-nvim-lsp' },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                snippet = {
                    expand = function(args)
                        -- You need Neovim v0.10 to use vim.snippet
                        vim.snippet.expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({}),
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Auto-completion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            { "nvim-java/nvim-java" }
        },
        config = function()
            local lspconfig_defaults = require('lspconfig').util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lspconfig_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set('n', 'gD', function() vim.lsp.buf.declaration() end, opts)
                    vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
                    vim.keymap.set('n', 'go', function() vim.lsp.buf.type_definition() end, opts)
                    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set('n', 'gs', function() vim.lsp.buf.signature_help() end, opts)
                    vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set({ 'n', 'x' }, 'gq', function() vim.lsp.buf.format({ async = true }) end, opts)
                    vim.keymap.set('n', '<F4>', function() vim.lsp.buf.code_action() end, opts)
                end,
            })

            local lspconfig = require('lspconfig')

            lspconfig.lua_ls.setup({})
            lspconfig.nil_ls.setup({})

            lspconfig.rust_analyzer.setup({})
            lspconfig.csharp_ls.setup({})
            lspconfig.jdtls.setup({})

            -- Javascript I guess
            -- lspconfig.tsserver.setup({})
            -- lspconfig.svelte.setup({})

            -- VSCode lsp's
            lspconfig.eslint.setup({})
            lspconfig.html.setup({})
            lspconfig.cssls.setup({})
            lspconfig.jsonls.setup({})
        end
    },
}
