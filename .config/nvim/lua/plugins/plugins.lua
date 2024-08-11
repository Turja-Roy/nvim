return {

    -- Git related plugins
    'tpope/vim-fugitive', -- Git commands from vim command line
    'tpope/vim-rhubarb', -- Companion of vim-fugitive
    -- Detect tabstop and shiftwidth automatically
    -- 'tpope/vim-sleuth',

    { -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim', opts = {}
    },

    { -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            -- char = '┊',
            -- show_trailing_blankline_indent = false,
        },
    },

    { -- "gc" to comment visual regions/lines
        'numToStr/Comment.nvim', opts = {}
    },

    { -- Working with latex files
        "lervag/vimtex",
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_quickfix_mode = 0
            vim.o.conceallevel = 1
            vim.cmd.syntax('enable')
        end,
        ft = 'tex',
    },

    { -- Autopairs
        'jiangmiao/auto-pairs'
    },

    { -- Snippets
        'honza/vim-snippets',
    },

    { -- Surround
        'tpope/vim-surround',
    },

    { -- Github Copilot
        'github/copilot.vim',
    },

    { -- vim visual multi
        'mg979/vim-visual-multi',
    },

    { -- nvim-notify
        'rcarriga/nvim-notify',
    },

    -- { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    --   'lewis6991/gitsigns.nvim',
    --   opts = {
    --     -- See `:help gitsigns.txt`
    --     signs = {
    --       add = { text = '+' },
    --       change = { text = '~' },
    --       delete = { text = '_' },
    --       topdelete = { text = '‾' },
    --       changedelete = { text = '~' },
    --     },
    --     on_attach = function(bufnr)
    --       vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
    --       vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
    --       vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
    --     end,
    --   },
    -- },

    -- require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',

    -- { import = 'custom.plugins' },

    { -- toggle-terminal
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true,
    },
}
