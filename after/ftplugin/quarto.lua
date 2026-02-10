-- Quarto-specific settings and keybindings
-- This file is automatically sourced when opening .qmd files

-- Buffer-local settings for better Quarto editing
vim.opt_local.conceallevel = 2 -- Hide markdown syntax for cleaner view
vim.opt_local.wrap = true -- Wrap long lines
vim.opt_local.linebreak = true -- Break at word boundaries
vim.opt_local.spell = true -- Enable spell checking for prose
vim.opt_local.spelllang = 'en_us'
vim.opt_local.textwidth = 0 -- Don't auto-wrap
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2

-- Helper function to insert a new code chunk
local function insert_code_chunk(lang)
	lang = lang or "python"
	local chunk = {
		"```{" .. lang .. "}",
		"",
		"```",
		""
	}
	local row = vim.api.nvim_win_get_cursor(0)[1]
	vim.api.nvim_buf_set_lines(0, row, row, false, chunk)
	-- Move cursor into the chunk
	vim.api.nvim_win_set_cursor(0, {row + 2, 0})
	vim.cmd('startinsert!')
end

-- Helper function to run quarto preview
local function quarto_preview()
	vim.cmd('ToggleTerm direction=vertical size=80')
	vim.cmd('TermExec cmd="quarto preview %"')
end

-- Helper function to run quarto render
local function quarto_render(format)
	local cmd = format and ("quarto render % --to " .. format) or "quarto render %"
	vim.cmd('ToggleTerm direction=horizontal size=25')
	vim.cmd('TermExec cmd="' .. cmd .. '"')
end

-- Buffer-local keybindings for Quarto
local opts = { buffer = true, silent = true }

-- Quarto preview and render
vim.keymap.set('n', '<leader>qp', quarto_preview, vim.tbl_extend('force', opts, { desc = 'Quarto preview' }))
vim.keymap.set('n', '<leader>qr', function() 
	-- Prompt for format
	vim.ui.input({ prompt = 'Render format (html/pdf/docx): ', default = 'html' }, function(format)
		if format then
			quarto_render(format)
		end
	end)
end, vim.tbl_extend('force', opts, { desc = 'Quarto render' }))

-- Insert code chunks
vim.keymap.set('n', '<leader>qir', function() insert_code_chunk('r') end, 
	vim.tbl_extend('force', opts, { desc = 'Insert R chunk' }))
vim.keymap.set('n', '<leader>qip', function() insert_code_chunk('python') end, 
	vim.tbl_extend('force', opts, { desc = 'Insert Python chunk' }))
vim.keymap.set('n', '<leader>qij', function() insert_code_chunk('julia') end, 
	vim.tbl_extend('force', opts, { desc = 'Insert Julia chunk' }))

-- Navigation helpers (jump between chunks)
-- These work with treesitter textobjects
vim.keymap.set('n', ']c', function()
	-- Jump to next code chunk
	vim.fn.search('^```{', 'W')
end, vim.tbl_extend('force', opts, { desc = 'Next code chunk' }))

vim.keymap.set('n', '[c', function()
	-- Jump to previous code chunk
	vim.fn.search('^```{', 'bW')
end, vim.tbl_extend('force', opts, { desc = 'Previous code chunk' }))

-- Helper function to execute current Python chunk with Molten
local function execute_python_chunk()
	-- Check if Molten is available
	if vim.fn.exists(':MoltenEvaluateVisual') == 0 then
		vim.notify("Molten not available. Initialize with <leader>mi first.", vim.log.levels.WARN)
		return
	end

	-- Save current cursor position
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = current_pos[1]
	
	-- Find chunk boundaries
	local chunk_start = nil
	local chunk_end = nil
	local is_python = false
	
	-- Search backwards for chunk start
	for i = current_line, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if line and line:match('^```{') then
			chunk_start = i
			-- Check if it's a Python chunk
			if line:match('^```{python') then
				is_python = true
			end
			break
		end
	end
	
	if not chunk_start or not is_python then
		vim.notify("Not in a Python chunk", vim.log.levels.WARN)
		return
	end
	
	-- Search forwards for chunk end
	local total_lines = vim.api.nvim_buf_line_count(0)
	for i = current_line, total_lines do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if line and line:match('^```%s*$') and i > chunk_start then
			chunk_end = i - 1
			break
		end
	end
	
	if not chunk_end then
		vim.notify("Could not find chunk end", vim.log.levels.WARN)
		return
	end
	
	-- Get chunk content (excluding the ``` markers)
	local content_start = chunk_start + 1
	local chunk_lines = vim.api.nvim_buf_get_lines(0, content_start - 1, chunk_end, false)
	
	-- Check if chunk has content
	local has_content = false
	for _, line in ipairs(chunk_lines) do
		if line:match('%S') then
			has_content = true
			break
		end
	end
	
	if not has_content then
		vim.notify("Chunk is empty", vim.log.levels.INFO)
		return
	end
	
	-- Execute with Molten
	vim.api.nvim_win_set_cursor(0, {content_start, 0})
	vim.cmd('normal! V')
	vim.api.nvim_win_set_cursor(0, {chunk_end, 0})
	vim.cmd('MoltenEvaluateVisual')
	
	-- Restore cursor position
	vim.api.nvim_win_set_cursor(0, current_pos)
	
	-- Clear visual selection
	vim.cmd('normal! ')
end

-- Execute current Python chunk with Molten
vim.keymap.set('n', '<leader>mc', execute_python_chunk,
	vim.tbl_extend('force', opts, { desc = 'Execute Python chunk (Molten)' }))

-- Automatically set up language detection for otter
-- This is already done in the otter plugin config, but we ensure it here
if pcall(require, 'otter') then
	require('otter').activate({ 'r', 'python', 'lua', 'bash', 'julia' })
end
