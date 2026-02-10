return {
	{
		"GCBallesteros/jupytext.nvim",
		config = true,
		lazy = false, -- Load immediately to handle .ipynb files
		-- Requires jupytext to be installed: pip install jupytext
		opts = {
			style = "percent", -- Use # %% cell markers (VSCode/Spyder style)
			output_extension = "py", -- Convert .ipynb to .py format
			force_ft = "python", -- Set filetype to python when editing
			custom_language_formatting = {
				python = {
					extension = "py",
					style = "percent",
					force_ft = "python",
				},
			},
		},
	},
}
