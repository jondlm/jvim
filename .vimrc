set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.jvim/bundle/vundle
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" My plugins
Plugin 'tpope/vim-fugitive'
Plugin 'altercation/vim-colors-solarized'

" All plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

