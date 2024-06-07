local K = vim.keymap.set

-- Shortcutting split navigation
K('n', '<C-H>', '<C-w>h')
K('n', '<C-J>', '<C-w>j')
K('n', '<C-K>', '<C-w>k')
K('n', '<C-L>', '<C-w>l')

-- Copy-pasting between nvim and other programs
K({'n', 'v'}, ',y', '"+y', { noremap = true })
K({'n', 'v'}, ',p', '"+p', { noremap = true })

-- nvim-tree configuration
-- K('n', ',n', function()
--     return require("nvim-tree.api").tree.toggle()
-- end
-- , { silent = true })

-- Moving lines or blocks of lines
K('n', '<A-j>', ':m .+1<CR>==', { silent = true })
K('n', '<A-k>', ':m .-2<CR>==', { silent = true })
K('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { silent = true })
K('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { silent = true })
K('v', '<A-j>', ':m \'>+1<CR>gv=gv', { silent = true })
K('v', '<A-k>', ':m \'<-2<CR>gv=gv', { silent = true })

-- Toggle *conceallevel
K('n', '<Leader>cc', [[:lua vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 1 or 0<CR>]], {noremap = true, silent = true})

-- Working with LaTeX
K('n', '<A-D>', ':!zathura --fork %:t:r.pdf<CR><CR>')
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.tex',
  command = 'execute "!pdflatex % >/dev/null 2>&1" | redraw!'
})

-- Open terminals using toggleterms
K('n', '<leader>tt', ':ToggleTerm<CR>')
K('n', '<leader>tf', ':ToggleTerm direction=float<CR>')
K('n', '<leader>th', ':ToggleTerm direction=horizontal size=25<CR>')
K('n', '<leader>tr', ':ToggleTerm direction=float<CR>ranger<CR>')
K('n', '<leader>tv', ':ToggleTerm direction=vertical size=70<CR>')

-- [[ C/C++/Java/Python compilation ]] --
K('n', '<F10>', ':w<CR>:split | terminal /home/turja/.local/bin/compile_and_run %<CR>I')
K('t', '<F10>', '<C-\\><C-n>:w<CR>:split | terminal /home/turja/.local/bin/compile_and_run %<CR>I')

-- [[ Java Project build and run ]] --
K('n', '<F9>', ':w<CR>:ToggleTerm<CR>compile_project<CR>')

-- [[Git keymaps]] --
-- K('n', '<leader>gs', ':split | terminal git pull && git add -A && zsh git commit -m \"Update \\$(date \'+\\%Y-\\%m-\\%d \\%H:\\%M\')\" && git push')

-- No op for space (leader) key
-- K({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Search highlight
-- K('n', '<leader>h', ':noh<CR>', { silent = true })

-- Remap for dealing with word wrap
K('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
K('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
K('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
K('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
K('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
K('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- Telescope keymaps
