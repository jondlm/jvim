# jVim

This started out as my personal vim config, but evolved to all my dot files.

Despite this being open source, it's built exclusively for me. Feel free to
look at the files but I wouldn't suggest actually installing it directly.

## Rough installation

1. `git clone git@github.com:jondlm/jvim ~/.jvim && cd ~/.jvim`
2. `git submodule update --init --recursive` downloads vundle
3. `./install.sh [bonus]` **warning**, will potentially overwrite existing dot
   files in your home directory. The script isn't long, just read it :)
4. Make sure your neovim version is updated
5. Use brew to install nushell (fzf, rustup, mise, alacritty, neovim, carapace)
10. Run vim, you'll get some errors, that's okay, just run `:BundleInstall`
11. Quit and restart vim
