return {
    {
        'nvim-java/nvim-java',
        config = function ()
            require('java').setup()
            -- Note: nvim-java handles LSP configuration internally
            -- The jdtls setup is managed by nvim-java plugin
            require('lspconfig').jdtls.setup({})
        end,
        ft = 'java',
    },
}
