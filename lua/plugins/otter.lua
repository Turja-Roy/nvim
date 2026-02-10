return {
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			lsp = {
				diagnostic_update_events = { "BufWritePost" },
			},
			buffers = {
				set_filetype = true,
				write_to_disk = false,
			},
			strip_wrapping_quote_characters = { "'", '"', "`" },
			handle_leading_whitespace = true,
		},
		config = function(_, opts)
			local otter = require("otter")
			otter.setup(opts)

			-- Auto-activate otter for quarto, markdown, and rmd files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "quarto", "markdown", "rmd" },
				callback = function()
					-- Activate otter for embedded languages
					otter.activate({ "r", "python", "lua", "bash", "julia" })
				end,
			})
		end,
	},
}
