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
Plugin 'arcticicestudio/nord-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'spf13/vim-autoclose'
Plugin 'flazz/vim-colorschemes'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'godlygeek/tabular'
Plugin 'mattn/emmet-vim'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'airblade/vim-gitgutter'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'xolox/vim-misc'
Plugin 'fmoralesc/vim-pad'
Plugin 'terryma/vim-expand-region'
Plugin 'w0rp/ale'
Plugin 'sheerun/vim-polyglot'
Plugin 'vimwiki/vimwiki'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sbdchd/neoformat'
Plugin 'ElmCast/elm-vim'
Plugin 'fatih/vim-go'
Plugin 'zchee/deoplete-go'
Plugin 'jremmen/vim-ripgrep'
Plugin 'junegunn/goyo.vim'
Plugin 'racer-rust/vim-racer'
Plugin 'sotte/presenting.vim'

" fzf
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plugin 'junegunn/fzf.vim'
" end fzf

" snipmate
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"Plugin 'MarcWeber/vim-addon-mw-utils'
"Plugin 'tomtom/tlib_vim'
"Plugin 'garbas/vim-snipmate'
" end snipmate

if has('nvim')
  Plugin 'Shougo/deoplete.nvim'
  Plugin 'mhartington/nvim-typescript'
else
  Plugin 'Shougo/neocomplcache.vim'
endif

" All plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


""""""""""""""""""""""""""""""""""""""""
" Colors
""""""""""""""""""""""""""""""""""""""""
"let g:solarized_termcolors=16
"let g:solarized_termtrans=1
"set background=dark
colorscheme nord
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
set backupdir=~/.vim/backup//   " Clean backups that arent stored in your current dir
set directory=~/.vim/swp//      " Clean swaps that arent stored in your current dir


""""""""""""""""""""""""""""""""""""""""
" Hooks
""""""""""""""""""""""""""""""""""""""""

" Syntax highlighting based on file extensions
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.less set filetype=less

" Clean trailing whitespace
autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()


""""""""""""""""""""""""""""""""""""""""
" Custom mappings
""""""""""""""""""""""""""""""""""""""""

" Easy tabs
map <S-H> gT
map <S-L> gt

" Be consistent with C and D
nnoremap Y y$

" Find merge conflict markers
map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" Search for visual selection
vnoremap // y/<C-R>"<CR>

" Force write the file for when you forget to use sudo
cmap w!! w !sudo tee % >/dev/null

" Adjust viewports to the same size
nmap <Leader>= <C-w>=

" Easier pane navigation
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>
nnoremap <silent> <c-l> :wincmd l<CR>
nnoremap <silent> <leader>m :wincmd R<CR>

if has('nvim')
  " Hack to get C-h working in NeoVim
  nnoremap <BS> <C-W>h
endif

" Execute contents of current line
nmap <Leader>x :exec 'r! ' . getline('.')<CR>
nmap <Leader>xx :call ReplaceAndExecLine()<CR>

" Easier file formatting
nmap <Leader>f gg=G

" Find and replace word under cursor
nmap <Leader>s :%s/\<<C-r><C-w>\>/

" Open file under cursor in a new tab
nmap <Leader>o <c-w>gf

" Make ' behave like ` for easier mark navigation
nmap ' `

" Makes * not jump to the next search item
" http://stackoverflow.com/a/4257175/895558
noremap * *``zz

" Fill the current line with dashes to 80 characters
noremap <Leader>- :call FillLine('-')<CR>

" Insert the current date
nmap <Leader>t "=strftime('%Y-%m-%d')<CR>P

" Search for visual selection
vnoremap // y/<C-R>"<CR>

" Base64 decode
vnoremap <leader>64d c<c-r>=system('base64 --decode', @")<cr><esc>
vnoremap <leader>64e c<c-r>=system('base64', @")<cr><esc>

""""""""""""""""""""""""""""""""""""""""
" JSX
""""""""""""""""""""""""""""""""""""""""
let g:jsx_ext_required = 0


""""""""""""""""""""""""""""""""""""""""
" Pad
""""""""""""""""""""""""""""""""""""""""
" Save notes to dropbox
let g:pad#dir = '/Users/jdelamotte/Dropbox/notes/'

" Make the quick window a little taller
let g:pad#window_height = 15

" Add an .md extension to new notes
let g:pad#default_file_extension = '.md'

" Use ag for searching cause it's the best
let g:pad#search_backend = 'ag'

" Disable default key bindings
let g:pad#set_mappings = 0

" Custom key bindings, the trailing whitespace here is intentional
nmap <Leader>nl :Pad ls<CR>
nmap <Leader>nn :Pad new 


""""""""""""""""""""""""""""""""""""""""
" JsDoc
""""""""""""""""""""""""""""""""""""""""
let g:jsdoc_default_mapping = 0


""""""""""""""""""""""""""""""""""""""""
" Goyo
""""""""""""""""""""""""""""""""""""""""
function! s:goyo_enter()
  silent !tmux set status off
  call deoplete#disable()
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  call deoplete#enable()
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

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
" Elixir
""""""""""""""""""""""""""""""""""""""""
autocmd BufWritePost *.exs silent :!mix format %
autocmd BufWritePost *.ex silent :!mix format %


""""""""""""""""""""""""""""""""""""""""
" Elm
""""""""""""""""""""""""""""""""""""""""
let g:elm_format_autosave = 1

autocmd FileType elm map <Leader>d :TSDef<CR>


""""""""""""""""""""""""""""""""""""""""
" Typescript
""""""""""""""""""""""""""""""""""""""""
autocmd FileType typescript map <Leader>d :TSDef<CR>


""""""""""""""""""""""""""""""""""""""""
" Go
""""""""""""""""""""""""""""""""""""""""
autocmd FileType go map <Leader>d :GoDef<CR>


""""""""""""""""""""""""""""""""""""""""
" Rust
""""""""""""""""""""""""""""""""""""""""
autocmd FileType rust map <Leader>d <Plug>(rust-def)

""""""""""""""""""""""""""""""""""""""""
" Airline
""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts=1
let g:airline_theme = 'nord'


""""""""""""""""""""""""""""""""""""""""
" EasyMotion
""""""""""""""""""""""""""""""""""""""""
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Bi-directional find motion
nmap s <Plug>(easymotion-s)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)


""""""""""""""""""""""""""""""""""""""""
" NerdTree
""""""""""""""""""""""""""""""""""""""""
map <C-e> :NERDTreeToggle<CR>
map <Leader>e :NERDTreeFind<CR>

" Remove this mapping cause I don't like it. Normally running an `unmap` on an
" already unmapped key throws an error, the `silent!` suppresses that.
silent! nunmap <Leader>nt

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let NERDTreeWinSize=60


""""""""""""""""""""""""""""""""""""""""
" Tabularize
""""""""""""""""""""""""""""""""""""""""
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
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
" Neocomplcache & Deoplete
""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#enable_smart_case = 1
  inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("j"))
  inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("k"))
  inoremap <expr> <Tab> ((pumvisible())?("\<C-n>"):("\<Tab>"))
  inoremap <expr> <S-Tab> ((pumvisible())?("\<C-p>"):("\<S-Tab>"))
else
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_auto_delimiter = 1
  let g:neocomplcache_max_list = 25
  let g:neocomplcache_force_overwrite_completefunc = 1
endif


""""""""""""""""""""""""""""""""""""""""
" Fzf.vim
""""""""""""""""""""""""""""""""""""""""
nmap <C-p> :GFiles<CR>
nmap <leader>p :Buffers<CR>
nmap <leader>; :History:<CR>
nmap <leader>/ :History/<CR>


""""""""""""""""""""""""""""""""""""""""
" Expand Region
""""""""""""""""""""""""""""""""""""""""
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)


""""""""""""""""""""""""""""""""""""""""
" GitGutter
""""""""""""""""""""""""""""""""""""""""
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap <Leader>r <Plug>GitGutterUndoHunk


""""""""""""""""""""""""""""""""""""""""
" VimWiki
""""""""""""""""""""""""""""""""""""""""
let wiki = {}
let wiki.path = '~/Dropbox/wiki'
let wiki.nested_syntaxes = {'javascript': 'javascript', 'yaml': 'yaml'}
let g:vimwiki_list = [wiki]
let g:vimwiki_folding = 1


""""""""""""""""""""""""""""""""""""""""
" Polyglot
""""""""""""""""""""""""""""""""""""""""
let g:polyglot_disabled = ['elm']


""""""""""""""""""""""""""""""""""""""""
" UtiliSnip
""""""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"


""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""
function! ReplaceAndExecLine()
  let template = getline('.')

  " This is hacky, but this line expects the first line if the file to have a
  " `let vars = {}` statement
  exec getline(1)

  for key in keys(vars)
    let template = substitute(template, key, get(vars, key), "g")
  endfor

  exec 'r! ' . template
endfunction

function! StripTrailingWhitespace()
  " Save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\(\|\s\)\+$//e
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

" fill rest of line with characters http://stackoverflow.com/a/3400528/895558
" Call with :call FillLine('-')
" Can also do `100A-<Esc>d80|` leveraging the column motion pipe character
function! FillLine( str )
  " set tw to the desired total length
  let tw = &textwidth
  if tw==0 | let tw = 80 | endif
  " strip trailing spaces first
  .s/[[:space:]]*$//
  " calculate total number of 'str's to insert
  let reps = (tw - col("$")) / len(a:str)
  " insert them, if there's room, removing trailing spaces (though forcing
  " there to be one)
  if reps > 0
    .s/$/\=(' '.repeat(a:str, reps))/
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""
" Overrides
""""""""""""""""""""""""""""""""""""""""

" Import the 'after' override file if it exists
if filereadable(expand('~/.vimrc-after'))
  source ~/.vimrc-after
endif

