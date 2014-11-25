set nocompatible              " be iMproved, required
filetype off                  " required

""""""""""""""""""""""""""""""""""""""""
" Vundle plugins
""""""""""""""""""""""""""""""""""""""""

" set the runtime path to include Vundle and initialize
set rtp+=~/.jvim/bundle/vundle
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'tpope/vim-surround'
Plugin 'spf13/vim-autoclose'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/powerline', {'rtp':'/powerline/bindings/vim'}
Plugin 'bling/vim-bufferline'
Plugin 'flazz/vim-colorschemes'
Plugin 'mbbill/undotree'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'Shougo/neocomplcache.vim'
Plugin 'godlygeek/tabular'
Plugin 'mattn/emmet-vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'groenewege/vim-less'
Plugin 'nono/vim-handlebars'
Plugin 'heartsentwined/vim-emblem'
Plugin 'Shutnik/jshint2.vim'
Plugin 'fatih/vim-go'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'airblade/vim-gitgutter'
Plugin 'Lokaltog/vim-easymotion'

" All plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


""""""""""""""""""""""""""""""""""""""""
" Colors
""""""""""""""""""""""""""""""""""""""""
let g:solarized_termcolors=16
let g:solarized_termtrans=1
set background=dark
colorscheme solarized
syntax on

highlight clear SignColumn
highlight GitGutterAdd           ctermfg=2 ctermbg=None
highlight GitGutterChange        ctermfg=3 ctermbg=None
highlight GitGutterDelete        ctermfg=1 ctermbg=None
highlight GitGutterChangeDelete  ctermfg=3 ctermbg=None

" Don't highlight special characters such as tabs and whitespace at EOL
highlight SpecialKey ctermbg=None

""""""""""""""""""""""""""""""""""""""""
" General Settings
""""""""""""""""""""""""""""""""""""""""
let mapleader = ' '
set clipboard=unnamed           " Wire up clipboard
set cursorline                  " Show line
set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=2                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
set history=1000                " Store a ton of history (default is 20)
set spell                       " Spell checking on
set cursorcolumn                " Include a vertical line for your cursor
set relativenumber              " Relative line numbers for easy motion command
set backupdir=~/.vim/backup//   " Clean backups that arent stored in your current dir
set directory=~/.vim/swp//      " Clean swaps that arent stored in your current dir

" Syntax highlighting based on file extensions
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.less set filetype=less
autocmd BufNewFile,BufRead *.hbs set filetype=handlebars
autocmd BufNewFile,BufRead *.emblem set filetype=emblem

" Relative line number when normal mode
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber
nnoremap <C-n> :call NumberToggle()<cr>


""""""""""""""""""""""""""""""""""""""""
" Custom mappings
""""""""""""""""""""""""""""""""""""""""

" Easy normal mode
imap ii <Esc>

" Easy tabs
map <S-H> gT
map <S-L> gt

" Be consistent with C and D
nnoremap Y y$

" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Run jshint
map <leader>j :JSHint<CR>

" JsDoc
let g:jsdoc_default_mapping = 0

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Adjust viewports to the same size
map <Leader>= <C-w>=

" Easier pane navigation
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Execute contents of current line
nnoremap <Leader>x :exec 'r! ' . getline('.')<CR>

" Clean trailing whitespace
autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()

" Insert date and time
nnoremap <Leader>d "=strftime("%FT%T%z")<CR>P


""""""""""""""""""""""""""""""""""""""""
" CtrlP
""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|bower_components'


""""""""""""""""""""""""""""""""""""""""
" Status Bar
""""""""""""""""""""""""""""""""""""""""

if has('statusline')
  set laststatus=2

  " Broken down into easily includeable segments
  set statusline=%<%f\                     " Filename
  set statusline+=%w%h%m%r                 " Options
  set statusline+=%{fugitive#statusline()} " Git Hotness
  set statusline+=\ [%{&ff}/%Y]            " Filetype
  set statusline+=\ [%{getcwd()}]          " Current dir
  set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endif



""""""""""""""""""""""""""""""""""""""""
" Airline
""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts=1
let g:airline_theme = 'solarized'



""""""""""""""""""""""""""""""""""""""""
" EasyMotion
""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
nmap f <Plug>(easymotion-s)
nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)


""""""""""""""""""""""""""""""""""""""""
" NerdTree
""""""""""""""""""""""""""""""""""""""""
map <C-e> :NERDTreeTabsToggle<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1


""""""""""""""""""""""""""""""""""""""""
" Tabularize
""""""""""""""""""""""""""""""""""""""""
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a,, :Tabularize /,\zs<CR>
vmap <Leader>a,, :Tabularize /,\zs<CR>
nmap <Leader>a" :Tabularize /\"<CR>
vmap <Leader>a" :Tabularize /\"<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>


""""""""""""""""""""""""""""""""""""""""
" Fugitive
""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _i_nteractive
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>


""""""""""""""""""""""""""""""""""""""""
" Neocomplcache
""""""""""""""""""""""""""""""""""""""""
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_max_list = 15
let g:neocomplcache_force_overwrite_completefunc = 1
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"


""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""
function! StripTrailingWhitespace()
  " Save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

