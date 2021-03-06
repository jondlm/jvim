#!/usr/bin/env bash

case "$(uname -s)" in
  Linux*)   os=linux;;
  Darwin*)  os=mac;;
  *)        echo "Unknown operating system" && exit 1
esac

echo "Adding vim backup and swap folders..."
mkdir -p ~/.vim/{backup,swp}
echo "Adding general backups folder..."
mkdir -p ~/.jvim/backups

echo "Backing up and symlinking .vimrc ..."
cp $HOME/.vimrc $HOME/.jvim/backups/.vimrc > /dev/null 2>&1
ln -sf $HOME/.jvim/.vimrc $HOME/.vimrc

echo "Setting up neovim..."
mkdir -p $HOME/.config
ln -sf $HOME/.vim $HOME/.config/nvim
ln -sf $HOME/.jvim/.vimrc $HOME/.config/nvim/init.vim

echo "Backing up symlinking UltiSnips snippets..."
cp -r $HOME/.vim/UltiSnips $HOME/.jvim/backups
rm -rf $HOME/.vim/UltiSnips
ln -sf $HOME/.jvim/bonus/UltiSnips $HOME/.vim

# Bonus
if [ "$1" = "bonus" ] ; then
  read -p "Would you like to backup and symlink .gitconfig? It has some details tied to Jon de la Motte. (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "Backing up and symlinking .gitconfig ..."
    cp $HOME/.gitconfig $HOME/.jvim/backups/.gitconfig > /dev/null 2>&1
    ln -sf $HOME/.jvim/bonus/.gitconfig $HOME/.gitconfig
  fi

  echo "Backing up and symlinking .tmux.conf ..."
  cp $HOME/.tmux.conf $HOME/.jvim/backups/.tmux.conf > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.tmux.conf $HOME/.tmux.conf

  echo "Backing up and symlinking .zshrc ..."
  cp $HOME/.zshrc $HOME/.jvim/backups/.zshrc > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.zshrc $HOME/.zshrc

  echo "Backing up and symlinking alacritty.yml ..."
  cp $HOME/.alacritty.yml $HOME/.jvim/backups/.alacritty.yml > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.alacritty.yml $HOME/.alacritty.yml

  echo "Backing up and symlinking .p10k.zsh ..."
  cp $HOME/.p10k.zsh $HOME/.jvim/backups/.p10k.zsh > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.p10k.zsh $HOME/.p10k.zsh

  echo "Backing up and symlinking .githooks ..."
  cp -r $HOME/.githooks $HOME/.jvim/backups/.githooks > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.githooks $HOME/.githooks

  if [ os = "mac" ]; then
    echo "Backing up and symlinking hammerspoon's init.lua & Spoons ..."
    cp $HOME/.hammerspoon/init.lua $HOME/.jvim/backups/init.lua > /dev/null 2>&1
    cp -r $HOME/.hammerspoon/Spoons $HOME/.jvim/backups/ > /dev/null 2>&1
    rm -rf $HOME/.hammerspoon/Spoons > /dev/null 2>&1
    ln -sf $HOME/.jvim/bonus/init.lua $HOME/.hammerspoon/init.lua
    ln -sf $HOME/.jvim/bonus/Spoons $HOME/.hammerspoon/Spoons
  fi
fi

echo "Installation complete"
