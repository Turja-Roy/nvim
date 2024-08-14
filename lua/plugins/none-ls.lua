return {
    "nvimtools/none-ls.nvim",
    keys = {
        { "<leader>bf", "<cmd>lua vim.lsp.buf.format()<CR>", desc = "Format buffer" },
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.shfmt,
                null_ls.builtins.formatting.clang_format,
                null_ls.builtins.formatting.google_java_format,
            },
        })
    end,
}
