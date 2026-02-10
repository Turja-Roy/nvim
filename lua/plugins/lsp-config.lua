return {
    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
            'folke/neodev.nvim',
        },

        config = function ()
            -- Setup neovim lua configuration
            require('neodev').setup()

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- Create LSP keybindings when a buffer attaches to an LSP
            local on_attach = function(_, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
                nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
                nmap('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')

                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-A-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                nmap('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')

                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                    vim.lsp.buf.format()
                end, { desc = 'Format current buffer with LSP' })
            end

            -- Configure R Language Server using native Neovim 0.11 API
            vim.lsp.config('r_language_server', {
                cmd = { 'R', '--slave', '-e', 'languageserver::run()' },
                filetypes = { 'r', 'rmd', 'quarto' },
                root_dir = vim.fs.root(0, {'.git', '.Rproj.user', '_quarto.yml'}),
                settings = {
                    r = {
                        lsp = {
                            diagnostics = true,
                            rich_documentation = true,
                        },
                    },
                },
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Configure Quarto LSP
            vim.lsp.config('quarto-lsp', {
                filetypes = { 'quarto', 'markdown' },
                root_dir = vim.fs.root(0, {'.git', '_quarto.yml', '_quarto.yaml'}),
                settings = {
                    quarto = {
                        diagnostics = {
                            enable = true,
                        },
                    },
                },
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Configure Python LSP (basedpyright)
            vim.lsp.config('basedpyright', {
                filetypes = { 'python', 'quarto' },
                root_dir = vim.fs.root(0, {'.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile'}),
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "openFilesOnly",
                        },
                    },
                },
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Configure Marksman (Markdown LSP)
            vim.lsp.config('marksman', {
                filetypes = { 'markdown', 'quarto', 'rmd' },
                root_dir = vim.fs.root(0, {'.git', '.marksman.toml'}),
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Example configurations for other servers (commented out)
            -- Uncomment and configure as needed:
            
            -- vim.lsp.config('lua_ls', {
            --     settings = {
            --         Lua = {
            --             runtime = { version = 'LuaJIT' },
            --             workspace = {
            --                 library = vim.api.nvim_get_runtime_file("", true),
            --                 checkThirdParty = false,
            --             },
            --             diagnostics = { globals = { 'vim' } },
            --         },
            --     },
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            -- })

            -- vim.lsp.config('clangd', {
            --     capabilities = capabilities,
            --     on_attach = on_attach,
            -- })

            -- Setup Mason and mason-lspconfig
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = { 
                    'r_language_server',
                    'quarto-lsp',
                    'basedpyright',
                    'marksman',
                },
                automatic_enable = true, -- Automatically enable installed servers
            })
        end,
    },
}
