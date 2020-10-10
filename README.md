# jVim

Yet another personal vim setup. Heavily inspired by [spf-13][spf]. Also
includes some other dot files I find useful.

## Installation

1. `git clone git@github.com:jondlm/jvim ~/.jvim && cd ~/.vim`
2. `git submodule update --init --recursive` downloads vundle
3. `./install.sh [bonus]` **warning**, will potentially overwrite existing dot
   files in your home directory. The script isn't long, just read it :)
4. Make sure your neovim version is updated
5. Install zsh (and maybe fzf, rustup, asdf, alacritty)
6. Clone zplug with `git clone git@github.com:zplug/zplug.git ~/.zplug`
7. Run `zsh` and `zplug install`
8. [mac] Run `brew install reattach-to-user-namespace` to get awesome clipboard support on mac
9. Run vim, you'll get some errors, that's okay, just run `:BundleInstall`
10. Quit and restart vim
11. Enjoy!

[brew]: http://brew.sh/
[spf]: http://vim.spf13.com/

