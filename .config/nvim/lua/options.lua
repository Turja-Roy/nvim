local o = vim.o
local wo = vim.wo
local g = vim.g
-- local bo = vim.bo

o.hlsearch = false
o.incsearch = true
wo.number = true
wo.relativenumber = true
-- o.mouse = 'a'
-- vim.o.clipboard = 'unnamedplus'
o.breakindent = true
o.undofile = true
o.ignorecase = true
o.smartcase = true
-- wo.signcolumn = 'yes'
o.splitright = true
o.splitbelow = true
vim.cmd([[autocmd BufEnter * set formatoptions-=cro]]) -- Disable auto commenting on newline

-- o.completeopt = 'menuone,noselect'
o.termguicolors = true
o.cursorline = true
o.cursorcolumn = true

-- Tab settings
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true
o.shiftwidth = 4
o.smarttab = true

-- Decrease update time
o.updatetime = 250
o.timeout = true
o.timeoutlen = 300

-- Turn off Indentline conceallevel overwrite
g.indentLine_setConceal = 0

-- VimTex configuration
g.tex_flavor = 'latex'
g.vimtex_view_method='zathura'
g.vimtex_quickfix_mode=0
o.conceallevel=1

-- nvim-tree configuration
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- NerdTree settings
-- K('n', '<C-N>', ':NERDTreeToggle<CR>', { noremap = true })
-- g.NERDTreeShowHidden = 1
-- g.NERDTreeModifiable = 1
-- g.NERDTreeQuitOnOpen = 1

-- Snippets configuration
g.UltiSnipsExpandTrigger="<Tab>"
-- g.UltiSnipsSnippetDirectories='/home/turja/.config/nvim/autoload/plugged/vim-snippets/UltiSnips'
g.UltiSnipsJumpForwardTrigger="<Tab>"
g.UltiSnipsJumpBackwardTrigger="<S-Tab>"


-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Github copilot tab settings
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
