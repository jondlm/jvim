# jVim

Yet another personal vim setup. Heavily inspired by [spf-13][spf]. Also
includes some other dot files I find useful.

## Installation

Mac instuctions:

1. *Optional*: `brew install ctags`
1. `git clone git@github.com:jondlm/jvim ~/.jvim`
1. `git submodule update --init --recursive` downloads vundle
1. `./install.sh [bonus]` **warning**, will potentially overwrite existing dot files in
   your home directory. The script is a few lines long, just read it :)
1. Run vim, you'll get some errors, that's okay, and `:BundleInstall`
1. Quit and restart vim
1. Enjoy!

[brew]: http://brew.sh/
[spf]: http://vim.spf13.com/

