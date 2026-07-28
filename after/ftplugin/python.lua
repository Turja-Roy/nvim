-- Python-specific settings for cell-based editing
-- Works with Jupyter notebooks (.ipynb via jupytext) and regular .py files with # %% cells

-- Helper function to insert a new cell
local function insert_cell()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lines = { "", "# %%", "" }
	vim.api.nvim_buf_set_lines(0, row, row, false, lines)
	-- Move cursor to the line after cell marker
	vim.api.nvim_win_set_cursor(0, {row + 3, 0})
	vim.cmd('startinsert!')
end

-- Helper function to jump to next cell
local function next_cell()
	vim.fn.search('^# %%', 'W')
end

-- Helper function to jump to previous cell
local function prev_cell()
	vim.fn.search('^# %%', 'bW')
end

-- Helper function to execute current cell with Molten
local function execute_current_cell()
	-- Check if Molten is available
	if vim.fn.exists(':MoltenEvaluateVisual') == 0 then
		vim.notify("Molten not available. Initialize with <leader>mi first.", vim.log.levels.WARN)
		return
	end

	-- Save current cursor position
	local current_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = current_pos[1]
	
	-- Find the start of the current cell (search backwards for # %%)
	local cell_start = current_line
	for i = current_line, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if line and line:match('^# %%') then
			cell_start = i
			break
		end
		if i == 1 then
			cell_start = 1
		end
	end
	
	-- Find the end of the current cell (search forwards for next # %%)
	local total_lines = vim.api.nvim_buf_line_count(0)
	local cell_end = total_lines
	for i = current_line + 1, total_lines do
		local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
		if line and line:match('^# %%') then
			cell_end = i - 1
			break
		end
	end
	
	-- Adjust start if it's on the cell marker itself
	if cell_start < total_lines then
		local start_line = vim.api.nvim_buf_get_lines(0, cell_start - 1, cell_start, false)[1]
		if start_line and start_line:match('^# %%') then
			cell_start = cell_start + 1
		end
	end
	
	-- Get cell content (excluding the # %% markers)
	local cell_lines = vim.api.nvim_buf_get_lines(0, cell_start - 1, cell_end, false)
	
	-- Skip empty cells
	local has_content = false
	for _, line in ipairs(cell_lines) do
		if line:match('%S') then -- Has non-whitespace
			has_content = true
			break
		end
	end
	
	if not has_content then
		vim.notify("Cell is empty", vim.log.levels.INFO)
		return
	end
	
	-- Select the cell content visually and execute with Molten
    local keys = string.format('%dGV%dG', cell_start, cell_end)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(keys, true, false, true),
        'x',
        false
    )
    vim.cmd('MoltenEvaluateVisual')
    -- vim.api.nvim_win_set_cursor(0, {cell_start, 0})
    -- vim.cmd('normal! V')
    -- vim.api.nvim_win_set_cursor(0, {cell_end, 0})
    -- vim.cmd('MoltenEvaluateVisual')

    -- Restore cursor position
    vim.api.nvim_win_set_cursor(0, current_pos)

    -- Clear visual selection
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
        'n',
        false
    )
    -- vim.cmd('normal! ')
end

-- Buffer-local keybindings for Python cells
local opts = { buffer = true, silent = true }

-- Cell navigation
vim.keymap.set('n', ']c', next_cell, vim.tbl_extend('force', opts, { desc = 'Next Python cell' }))
vim.keymap.set('n', '[c', prev_cell, vim.tbl_extend('force', opts, { desc = 'Previous Python cell' }))

-- Insert new cell
vim.keymap.set('n', '<leader>ic', insert_cell, vim.tbl_extend('force', opts, { desc = 'Insert Python cell' }))

-- Execute current cell with Molten (smart detection)
vim.keymap.set('n', '<leader>mc', execute_current_cell, 
    vim.tbl_extend('force', opts, { desc = 'Execute current cell (Molten)' }))

-- Quick Molten helpers (in addition to global <leader>m* bindings)
-- These are just convenience shortcuts for Python files
vim.keymap.set('n', '<leader>mp', ':MoltenInit python3<CR>', 
    vim.tbl_extend('force', opts, { desc = 'Start Python3 kernel' }))

-- Note: Iron.nvim already configured for Python with # %% dividers
-- So <leader>xb and <leader>xn will work for sending cells to REPL

-- Visual feedback: highlight cell markers
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    buffer = 0,
    callback = function()
        -- Highlight # %% cell markers
        vim.fn.matchadd('Comment', '^# %%.*')
    end,
})
