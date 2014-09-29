# jVim

Yet another personal vim setup. Heavily inspired by [spf-13][spf]. Also
includes some other dot files I find useful.

## Installation

Mac instuctions:

1. *Optional*: `brew install ctags`
1. `git clone git@github.com:jondlm/jvim ~/.jvim`
1. `git submodule update --init --recursive` downloads vundle
1. `curl -L http://install.ohmyz.sh | sh` install *oh my zsh*
1. `./install.sh [bonus]` **warning**, will potentially overwrite existing dot files in
   your home directory. The script is a few lines long, just read it :)
1. Make sure your vim version is updated, if you're on mac this would be with `brew install vim` and `sudo mv /usr/bin/vim /usr/bin/vim-old`
1. Run `brew install reattach-to-user-namespace` to get awesome clipboard support on mac
1. Run vim, you'll get some errors, that's okay, just run `:BundleInstall`
1. Quit and restart vim
1. Enjoy!

[brew]: http://brew.sh/
[spf]: http://vim.spf13.com/

