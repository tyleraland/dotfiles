" Startup
set shellcmdflag=-ic " Make ex's :! behave like command prompt

" Session
syntax enable
set ruler          " show line number on the bar
set cursorline
set shiftwidth=4 " Specifies amount of whitespace to insert/delete when indenting in normal mode
set tabstop=4 " Width of tab character
set autoindent
set showcmd
set expandtab " Uses spaces in lieu of tab characters .. Use ctrl-v <TAB> to literal insert tab
set history=500
set undolevels=1000 " 1000 undos
set shell=bash
set hlsearch
set backup
set relativenumber "Line numbers relative to current line
set backspace=2

if has("autocmd")
    " Enable filetype detection
    " Try ':set filetype name'
    filetype on
    " These files are fussy about tabs versus spaces
    autocmd FileType make setlocal sw=8 sts=8 ts=8 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentexpr=GetYAMLIndent()
    autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
    " SConstruct is just python
    autocmd BufNewFile,BufRead SConstruct,SConscript,*.scons setfiletype python

endif

" Attempt at colors
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
    set t_Co=256
endif

" Pathogen
silent! call pathogen#infect()
silent! call pathogen#helptags() "generate helptags for everything in runtimepath

filetype plugin indent on

" Vim-colors solarized http://ethanschoonover.com/solarized/vim-colors-solarized
let g:solarized_termtrans = 1 " highlights cursorline
set background=dark
"set background=light
colorscheme solarized


" When ':set list' is invoked, show EOL as NOT-symbol ¬ and tabs as triangle ▸
" insert-mode, ctrl-v "u00ac" and "u25b8" will make ¬ and ▸ respectively
" set listchars=tab:▸\ ,eol:¬

" See :help ft-python-indent for information on indent by expression
" By default python files are subject to indentexpr=GetPythonIndent(v:lnum)
" By Default, the following indentations are doubled.  Too much for me.
let g:pyindent_open_paren = '&sw'
let g:python_continue = '&sw'

" Code folding settings.
" cheatsheet: `za`-toggles `zc`-closes `zo`-opens `zR'-openAll `zM`-closeall
set foldmethod=indent
set foldnestmax=10  "deepest fold is 10 levels
set nofoldenable    "don't fold by default
set foldlevel=1     "Try others

"" Supertab
"let g:SuperTabDefaultCompletionType = "context" " Will trigger the jedi-vim popup on tab after dot

"    " Always open with NERDTree
"    autocmd StdinReadPre * let s:std_in=1
"    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" MacVim only
if has('gui_macvim')
    set guifont=Monaco:h15
    set norelativenumber
    set spell "spellcheck
    autocmd vimenter * NERDTree " Open NERDTree on startup
    " Close vim if the only window left is NERDTree
"    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endif

if $TMUX == ''
    set clipboard+=unnamed
endif
" Highlight trailing whitespace after leaving insert mode
au InsertLeave * match Errormsg /\s\+\%#\@<!$/

"indentexpr=GetYAMLIndent(v:lnum)
