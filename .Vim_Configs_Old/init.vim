let mapleader=" "

call plug#begin('~/.config/nvim/autoload/plugged')

" Themes
Plug 'ghifarit53/tokyonight-vim'
" Plug 'arcticicestudio/nord-vim', {'for': 'tex'}
" Plug 'EdenEast/nightfox.nvim'
" Plug 'sainnhe/sonokai'
" Plug 'savq/melange'

" Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'sheerun/vim-polyglot'
Plug 'Yggdroot/indentLine'
" Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
" Plug 'christoomey/vim-titlecase'
" Plug 'christoomey/vim-system-copy'
Plug 'jiangmiao/auto-pairs'
" Plug 'tpope/vim-eunuch'
Plug 'vim-airline/vim-airline'
Plug 'elkowar/yuck.vim', {'for': 'yuck'}
Plug 'lervag/vimtex'

call plug#end()

" Themes
set termguicolors
let g:tokyonight_style = 'storm'
colorscheme nightfox

" Turn off Indentline conceallevel overwrite
let g:indentLine_setConceal = 0

" VimTex configuration
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" Snippets configuration
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

" Jump outside '"({
if !exists('g:AutoPairsShortcutJump')
  let g:AutoPairsShortcutJump = '<C-h>'
endif

" Some basics:
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
	set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab

" Enable autocompletion:
	set wildmode=longest,list,full

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Shortcutting split navigation:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

 " " Shortcut for goyo:
 "    map <leader>f :Goyo <CR>

" Copy-pasting between vim and other programs
    noremap <Leader>y "+y
    noremap <Leader>p "+p

" Stop search highlighting
    nnoremap <Leader>/ :noh<cr>       

    
" Moving lines or blocks of lines
    nnoremap <A-j> :m .+1<CR>==
    nnoremap <A-k> :m .-2<CR>==
    inoremap <A-j> <Esc>:m .+1<CR>==gi
    inoremap <A-k> <Esc>:m .-2<CR>==gi
    vnoremap <A-j> :m '>+1<CR>gv=gv
    vnoremap <A-k> :m '<-2<CR>gv=gv

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck %<CR>

" Working with LaTeX:
    map <A-D> :!zathura --fork %:t:r.pdf<CR><CR>
    autocmd BufWritePost *.tex execute "!pdflatex % >/dev/null 2>&1" | redraw!

" Toggle *conceallevel*
    nnoremap <Leader>c :set <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=1'<CR><CR>

" Ignore case while searching
	set ignorecase

" Split settings
	set splitbelow splitright

" NERDtree settings
	map <C-N> :NERDTreeToggle<CR>
	let NERDTreeShowHidden=1
	let NERDTreeQuitOnOpen=1

	" inoremap {<CR> {<CR>}<Esc>ko<tab>
	" inoremap [<CR> [<CR>]<Esc>ko<tab>
	" inoremap (<CR> (<CR>)<Esc>ko<tab>

	" inoremap " ""<Esc>ha
	" inoremap ' ''<Esc>ha
	" inoremap ` ``<Esc>ha
	" inoremap < <><Esc>ha
    
" Spellcheck
    setlocal spell
    set spelllang=nl,en_us
    inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
    set nospell
