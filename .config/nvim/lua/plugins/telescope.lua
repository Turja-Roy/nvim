return {

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },

        config = {
            defaults = {
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false,
                    },
                },
                -- telescope ignore filetypes in Find Files
                file_ignore_patterns = {
                    "bin/.*",
                    "res/.*",
                    -- "*.class",
                    -- "*.png",
                },
            },
        },
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,

        config = function ()
            local K = vim.keymap.set

            -- Enable telescope fzf native, if installed
            pcall(require('telescope').load_extension, 'fzf')

            -- See `:help telescope.builtin`
            K('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
            K('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
            K('n', '<leader>/', function()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })

            K('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
            K('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
            K('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
            K('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
            K('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
            K('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

        end
    },

    -- Git worktree integration
    {
        'nvim-lua/popup.nvim',

        config = function ()
            local K = vim.keymap.set

            K('n', '<leader>gw', require('telescope').extensions.git_worktree.git_worktrees, { desc = '[G]it [W]orktrees' })
        end
    },

    -- UI for telescope
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function ()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            }
            require("telescope").load_extension("ui-select")
        end
    }

}
