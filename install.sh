echo "Symlinking .vimrc ..."
ln -sf $HOME/.jvim/.vimrc $HOME/.vimrc

# Bonus
if [ "$1" = "bonus" ] ; then
  echo "Symlinking .gitconfig ..."
  ln -sf $HOME/.jvim/bonus/.gitconfig $HOME/.gitconfig

  echo "Symlinking .tmux.conf ..."
  ln -sf $HOME/.jvim/bonus/.tmux.conf $HOME/.tmux.conf

  echo "Symlinking .zshrc ..."
  ln -sf $HOME/.jvim/bonus/.zshrc $HOME/.zshrc

  echo "Symlinking .ctags ..."
  ln -sf $HOME/.jvim/bonus/.ctags $HOME/.ctags

  echo "Symlinking garybernhart/dotfiles binaries to $HOME/bin ..."
  mkdir -p $HOME/bin
  ln -sf $HOME/.jvim/bonus/garys-dotfiles/bin/* $HOME/bin

  echo "Symlinking .githelpers ..."
  ln -sf $HOME/.jvim/bonus/garys-dotfiles/.githelpers $HOME/.githelpers
fi

echo "Installation complete"
