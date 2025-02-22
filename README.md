# jVim

Yet another personal vim setup. Heavily inspired by [spf-13][spf]. Also
includes some other dot files I find useful.

## Installation

**Note**: These instructions aren't precise.

1. `git clone git@github.com:jondlm/jvim ~/.jvim && cd ~/.jvim`
2. `git submodule update --init --recursive` downloads vundle
3. `./install.sh [bonus]` **warning**, will potentially overwrite existing dot
   files in your home directory. The script isn't long, just read it :)
4. Make sure your neovim version is updated
5. Use brew to install zsh (fzf, rustup, mise, alacritty, neovim, zplug)
8. Run `zsh` and `zplug install`
10. Run vim, you'll get some errors, that's okay, just run `:BundleInstall`
11. Quit and restart vim
12. Enjoy!

[spf]: http://vim.spf13.com/

