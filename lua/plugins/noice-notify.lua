return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        messages = {
            enabled = false,
        },
        lsp = {
            progress = {
                enabled = false,
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                ["vim.lsp.util.stylize_markdown"] = false,
                ["cmp.entry.get_documentation"] = false,
            },
        },
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        {
            'rcarriga/nvim-notify',
            opts = {
                stages = "slide",
                timeout = 2000,
                background_colour = "#000000",
                minimum_width = 50,
                max_width = 100,
                max_height = 20,
                render = "default",
            },
        },
    },
}
