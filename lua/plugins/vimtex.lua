return { -- Working with latex files
	"lervag/vimtex",
	init = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_matchparens_enabled = 0
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
