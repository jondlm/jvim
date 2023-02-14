#!/usr/bin/env bash

case "$(uname -s)" in
  Linux*)   os=linux;;
  Darwin*)  os=mac;;
  *)        echo "Unknown operating system" && exit 1
esac

BACKUP_DIR="$HOME/.jvim/backups/$(date +%s)"

echo "Adding vim backup and swap folders ..."
mkdir -p $HOME/.vim/{backup,swp}

echo "Creating backup folder at $BACKUP_DIR ..."
mkdir -p $BACKUP_DIR

echo "Backing up and symlinking .vimrc ..."
cp $HOME/.vimrc $BACKUP_DIR/.vimrc > /dev/null 2>&1
ln -sf $HOME/.jvim/.vimrc $HOME/.vimrc

echo "Setting up neovim..."
mkdir -p $HOME/.config
ln -sf $HOME/.vim $HOME/.config/nvim
ln -sf $HOME/.jvim/.vimrc $HOME/.config/nvim/init.vim

echo "Backing up symlinking UltiSnips snippets..."
cp -r $HOME/.vim/UltiSnips $BACKUP_DIR
rm -rf $HOME/.vim/UltiSnips
ln -sf $HOME/.jvim/bonus/UltiSnips $HOME/.vim

# Bonus
if [ "$1" = "bonus" ] ; then
  if [ "$2" = "gitconfig" ] ; then
    echo "Backing up and symlinking .gitconfig ..."
    cp $HOME/.gitconfig $BACKUP_DIR/.gitconfig > /dev/null 2>&1
    ln -sf $HOME/.jvim/bonus/.gitconfig $HOME/.gitconfig
  fi

  echo "Backing up and symlinking .tmux.conf ..."
  cp $HOME/.tmux.conf $BACKUP_DIR/.tmux.conf > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.tmux.conf $HOME/.tmux.conf

  echo "Backing up and symlinking .zshrc ..."
  cp $HOME/.zshrc $BACKUP_DIR/.zshrc > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.zshrc $HOME/.zshrc

  echo "Backing up and symlinking alacritty.yml ..."
  cp $HOME/.alacritty.yml $BACKUP_DIR/.alacritty.yml > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.alacritty.yml $HOME/.alacritty.yml

  echo "Backing up and symlinking .p10k.zsh ..."
  cp $HOME/.p10k.zsh $BACKUP_DIR/.p10k.zsh > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.p10k.zsh $HOME/.p10k.zsh

  echo "Backing up and symlinking .githooks ..."
  cp -r $HOME/.githooks $BACKUP_DIR/.githooks > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.githooks $HOME/.githooks

  echo "Backing up and symlinking ranger rc.conf ..."
  cp -r $HOME/.config/ranger/rc.conf $BACKUP_DIR/rc.conf > /dev/null 2>&1
  mkdir -p $HOME/.config/ranger
  ln -sf $HOME/.jvim/bonus/rc.conf $HOME/.config/ranger/rc.conf

  if [ "$os" = "mac" ]; then
    echo "Backing up and symlinking hammerspoon's init.lua & Spoons ..."
    cp $HOME/.hammerspoon/init.lua $BACKUP_DIR/init.lua > /dev/null 2>&1
    cp -r $HOME/.hammerspoon/Spoons $BACKUP_DIR/ > /dev/null 2>&1
    rm -rf $HOME/.hammerspoon/Spoons > /dev/null 2>&1
    ln -sf $HOME/.jvim/bonus/init.lua $HOME/.hammerspoon/init.lua
    ln -sf $HOME/.jvim/bonus/Spoons $HOME/.hammerspoon/Spoons

    echo "Backing up and symlinking .yabairc ..."
    cp $HOME/.yabairc $BACKUP_DIR/.yabairc > /dev/null 2>&1
    ln -sf $HOME/.jvim/bonus/.yabairc $HOME/.yabairc

    echo "Backing up and symlinking .skhdrc ..."
    cp $HOME/.skhdrc $BACKUP_DIR/.skhdrc > /dev/null 2>&1
    ln -sf $HOME/.jvim/bonus/.skhdrc $HOME/.skhdrc
  fi
fi

echo "Installation complete"
