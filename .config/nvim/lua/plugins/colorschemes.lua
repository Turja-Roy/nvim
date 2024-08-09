return {
    -- { -- Onedark
    --     'navarasu/onedark.nvim',
    --     priority = 1000,
    --     config = function()
    --         require('onedark').setup({
    --             -- style = 'warmer'
    --             -- style = 'dark'
    --             -- style = 'warm'
    --             -- style = 'cool'
    --             -- style = 'darker'
    --             style = 'deep'
    --         })
    --         vim.cmd.colorscheme 'onedark'
    --     end,
    -- },
    -- { -- Cyberdream
    --     "scottmckendry/cyberdream.nvim",
    --     lazy = false,
    --     priority = 1000,
    --
    --     config = function ()
    --         require("lualine").setup({
    --             -- ... other config
    --             options = {
    --                 theme = "auto", -- "auto" will set the theme dynamically based on the colorscheme
    --             },
    --             -- ... other config
    --         })
    --         vim.cmd.colorscheme 'cyberdream'
    --     end
    -- },
    { -- Catpuccin
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        -- colorscheme catppuccin, " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
        config = function ()
            require('catppuccin').setup({
                flavour = "mocha",
                background = {
                    light = "latte",
                    dark = "mocha",
                },
            })
            vim.cmd.colorscheme 'catppuccin'
        end
    },
    -- {
    --     "tiagovla/tokyodark.nvim",
    --     opts = {
    --         -- custom options here
    --     },
    --     config = function(_, opts)
    --         require("tokyodark").setup(opts) -- calling setup is optional
    --         vim.cmd [[colorscheme tokyodark]]
    --     end,
    -- },
}
