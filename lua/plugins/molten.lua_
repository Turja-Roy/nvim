return {
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
		dependencies = {
			"3rd/image.nvim",
		},
		build = ":UpdateRemotePlugins",
		init = function()
			-- Configuration for molten
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_auto_open_output = true
			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = true
			vim.g.molten_virt_lines_off_by_1 = true
			
			-- Configure for tmux + kitty compatibility
			vim.g.molten_use_border_highlights = true
			vim.g.molten_cover_empty_lines = false
			
			-- Don't auto-initialize - we'll do it manually per-project
			vim.g.molten_auto_init_behavior = "raise"
			
			-- Enter output window automatically
			vim.g.molten_enter_output_behavior = "open_and_enter"
		end,
		keys = {
			{ "<leader>mi", ":MoltenInit<CR>", desc = "Initialize Molten kernel" },
			{ "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Evaluate operator", mode = "n" },
			{ "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Evaluate line", mode = "n" },
			{ "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell" },
			{ "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Evaluate visual selection", mode = "v" },
			{ "<leader>md", ":MoltenDelete<CR>", desc = "Delete Molten cell" },
			{ "<leader>mo", ":MoltenShowOutput<CR>", desc = "Show Molten output" },
			{ "<leader>mh", ":MoltenHideOutput<CR>", desc = "Hide Molten output" },
			{ "<leader>mx", ":MoltenInterrupt<CR>", desc = "Interrupt Molten kernel" },
			{ "<leader>mR", ":MoltenRestart!<CR>", desc = "Restart Molten kernel" },
		},
	},
	{
		"3rd/image.nvim",
		opts = {
			backend = "kitty",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "markdown", "vimwiki", "quarto", "rmd" },
				},
			},
			max_width = nil,
			max_height = nil,
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = false,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		},
	},
}
