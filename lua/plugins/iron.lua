return {
	{
		"Vigemus/iron.nvim",
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")

			iron.setup {
				config = {
					scratch_repl = true,
					repl_definition = {
						sh = {
							command = {"bash"},
							block_dividers = { "# %%", "#%%" },
						},
						python = {
							command = { "python3" },
							format = require("iron.fts.common").bracketed_paste,
							block_dividers = { "# %%", "#%%" },
						},
						r = {
							command = {"R", "--quiet", "--no-save"},
							block_dividers = { "```", "``` r", "```r", "```{r}" },
						},
						rmd = {
							command = {"R", "--quiet", "--no-save"},
							block_dividers = { "```", "``` r", "```r", "```{r}" },
						},
						quarto = {
							command = {"R", "--quiet", "--no-save"},
							block_dividers = { "```", "``` r", "```r", "```{r}" },
						},
						markdown = {
							command = {"R", "--quiet", "--no-save"},
							block_dividers = { "```", "``` r", "```r", "```{r}" },
						},
					},
					-- Open as a normal split window that you can navigate to
					repl_open_cmd = view.split.vertical.botright("50%"),
				},
				keymaps = {
					send_motion = "<leader>xc",
					visual_send = "<leader>xc",
					send_file = "<leader>xf",
					send_line = "<leader>xl",
					send_until_cursor = "<leader>xu",
					send_mark = "<leader>xm",
					mark_motion = "<leader>xM",
					mark_visual = "<leader>xM",
					remove_mark = "<leader>xd",
					cr = "<leader>x<cr>",
					interrupt = "<leader>x<space>",
					exit = "<leader>xq",
					clear = "<leader>xC",
				},
				highlight = {
					italic = true
				},
				ignore_blank_lines = true,
			}

			-- Simple keymaps using <leader>x prefix
			vim.keymap.set('n', '<leader>xs', '<cmd>IronRepl<cr>', { desc = "Start Iron REPL" })
			vim.keymap.set('n', '<leader>xr', '<cmd>IronRestart<cr>', { desc = "Restart Iron REPL" })
			vim.keymap.set('n', '<leader>xh', '<cmd>IronHide<cr>', { desc = "Hide Iron REPL" })
			vim.keymap.set('n', '<leader>xF', '<cmd>IronFocus<cr>', { desc = "Focus Iron REPL" })
			
			-- Code block/cell keybindings
			vim.keymap.set('n', '<leader>xb', function()
				require('iron.core').send_code_block(false)
			end, { desc = "Send code block/cell" })
			
			vim.keymap.set('n', '<leader>xn', function()
				require('iron.core').send_code_block(true)
			end, { desc = "Send code block and move to next" })
			
			-- Make TmuxNavigate work in terminal mode (REPL)
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "*",
				callback = function()
					vim.keymap.set('t', '<C-h>', '<C-\\><C-n>:TmuxNavigateLeft<CR>', { buffer = true, silent = true })
					vim.keymap.set('t', '<C-j>', '<C-\\><C-n>:TmuxNavigateDown<CR>', { buffer = true, silent = true })
					vim.keymap.set('t', '<C-k>', '<C-\\><C-n>:TmuxNavigateUp<CR>', { buffer = true, silent = true })
					vim.keymap.set('t', '<C-l>', '<C-\\><C-n>:TmuxNavigateRight<CR>', { buffer = true, silent = true })
				end,
			})
		end
	},
}
