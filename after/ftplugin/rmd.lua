-- R Markdown specific settings and keybindings
-- This file is automatically sourced when opening .rmd files

-- Buffer-local settings for better R Markdown editing
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
	lang = lang or "r"
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

-- Helper function to run preview (using Quarto)
local function rmd_preview()
	vim.cmd('ToggleTerm direction=vertical size=80')
	vim.cmd('TermExec cmd="quarto preview %"')
end

-- Helper function to render R Markdown
local function rmd_render(method)
	method = method or "quarto"
	local cmd
	
	if method == "quarto" then
		-- Use Quarto to render (modern, recommended)
		local format = vim.fn.input("Render format (html/pdf/docx): ", "html")
		if format == "" then format = "html" end
		cmd = "quarto render % --to " .. format
	else
		-- Use traditional rmarkdown::render
		local format = vim.fn.input("Output format (html_document/pdf_document): ", "html_document")
		if format == "" then format = "html_document" end
		cmd = "R -e \"rmarkdown::render('" .. vim.fn.expand("%") .. "', output_format='" .. format .. "')\""
	end
	
	vim.cmd('ToggleTerm direction=horizontal size=25')
	vim.cmd('TermExec cmd="' .. cmd .. '"')
end

-- Buffer-local keybindings for R Markdown
local opts = { buffer = true, silent = true }

-- Preview and render (using Quarto by default)
vim.keymap.set('n', '<leader>qp', rmd_preview, vim.tbl_extend('force', opts, { desc = 'R Markdown preview (Quarto)' }))
vim.keymap.set('n', '<leader>qr', function() 
	rmd_render("quarto")
end, vim.tbl_extend('force', opts, { desc = 'R Markdown render (Quarto)' }))

-- Alternative: render with traditional rmarkdown package
vim.keymap.set('n', '<leader>qR', function()
	rmd_render("rmarkdown")
end, vim.tbl_extend('force', opts, { desc = 'R Markdown render (rmarkdown)' }))

-- Insert code chunks
vim.keymap.set('n', '<leader>qir', function() insert_code_chunk('r') end, 
	vim.tbl_extend('force', opts, { desc = 'Insert R chunk' }))
vim.keymap.set('n', '<leader>qip', function() insert_code_chunk('python') end, 
	vim.tbl_extend('force', opts, { desc = 'Insert Python chunk' }))
vim.keymap.set('n', '<leader>qij', function() insert_code_chunk('julia') end, 
	vim.tbl_extend('force', opts, { desc = 'Insert Julia chunk' }))

-- Navigation helpers (jump between chunks)
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
