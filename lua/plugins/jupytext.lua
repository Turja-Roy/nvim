return {
    {
        "sheng-tse/jupynvim",
        build = function(plugin)
            local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
            install.run(plugin)
        end,
        config = function()
            require("jupynvim").setup({
                log_level = "info",
                image_renderer = "placeholder",
            })
        end,
        lazy = false, -- Load immediately to handle .ipynb files
        init = function()
            vim.api.nvim_create_autocmd("BufWinEnter", {
                pattern = "*.ipynb",
                callback = function()
                    vim.opt_local.number = true
                    vim.opt_local.relativenumber = true
                end,
            })
        end,
    },
}

-------------------------
-- Guide to shortcuts: --
-------------------------

-- - <S-CR> or <leader>nr - run cell, advance
-- - <C-CR> - run cell, stay
-- - <leader>nR - run all cells
-- - <leader>nA / <leader>nB - run all cells above/below
-- - <leader>na / <leader>nb - add cell above/below
-- - <leader>nd - delete cell
-- - <leader>nk / <leader>nj - move cell up/down
-- - <leader>nm / <leader>ny - convert to markdown/code
-- - <leader>nc / <leader>nC - clear current cell output / clear all
-- - ]c / [c - next/prev cell
-- - <C-j> / <C-k> - enter next/prev cell output split
-- - <leader>nI - save current cell image
-- - <leader>nD - delete embedded markdown image
-- - ]i / [i - next/prev cell with image
-- - <leader>nK - pick kernel
-- - <leader>ns / <leader>nS - start/stop kernel
-- - <leader>ni - interrupt kernel
-- - <leader>nx - restart kernel
-- - <leader>nL - force re-render
