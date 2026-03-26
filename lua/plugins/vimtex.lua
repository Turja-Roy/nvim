return { -- Working with latex files
	"lervag/vimtex",
	init = function()
		vim.g.tex_flavor = "latex"
        vim.g.vimtex_compiler_latexmk_engines = {
            _ = "-lualatex"
        }
        -- vim.g.vimtex_compiler_latexmk = {
        --     engine = 'xelatex', -- options: pdflatex, xelatex, lualatex
        --     callback = 0,  -- Disable callback to prevent premature viewer open
        -- }
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_quickfix_mode = 0
        vim.g.vimtex_matchparens_enabled = 0
        -- vim.g.vimtex_compiler_latexmk = {
        --     build_dir = '',
        --     continuous = 1,
        --     options = {
        --         '-verbose',
        --         '-file-line-error',
        --         '-synctex=1',
        --         '-interaction=nonstopmode',
        --     },
        -- }
        vim.g.vimtex_quickfix_ignore_filters = {
            'Underfull \\hbox',
            'Overfull \\hbox',
            'Package.*Warning',
        }
        vim.o.conceallevel = 1
        vim.cmd.syntax("enable")
        vim.api.nvim_create_autocmd("VimLeave", {
            pattern = "*.tex",
            callback = function()
                os.execute([[
                  find . -type f \( -name "*.aux" -o -name "*.log" -o -name "*.synctex.gz" \
                  -o -name "*.bbl" -o -name "*.blg" -o -name "*.fls" \
                  -o -name "*.fdb_latexmk" -o -name "*.out" \
                  -o -name "*.lof" -o -name "*.lot" \) -delete
                ]])
            end,
        })
    end,
    ft = "tex",
}
