echo "Adding vim backup and swap folders..."
mkdir -p ~/.vim/{backup,swp}
echo "Adding general backups folder..."
mkdir -p ~/.jvim/backups

echo "Backing up and symlinking .vimrc ..."
cp $HOME/.vimrc $HOME/.jvim/backups/.vimrc > /dev/null 2>&1
ln -sf $HOME/.jvim/.vimrc $HOME/.vimrc

# Bonus
if [ "$1" = "bonus" ] ; then
  echo "Backing up and symlinking .gitconfig ..."
  cp $HOME/.gitconfig $HOME/.jvim/backups/.gitconfig > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.gitconfig $HOME/.gitconfig

  echo "Backing up and symlinking .tmux.conf ..."
  cp $HOME/.tmux.conf $HOME/.jvim/backups/.tmux.conf > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.tmux.conf $HOME/.tmux.conf

  echo "Backing up and symlinking .zshrc ..."
  cp $HOME/.zshrc $HOME/.jvim/backups/.zshrc > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.zshrc $HOME/.zshrc

  echo "Backing up and symlinking jeeef zsh theme ..."
  cp $HOME/.oh-my-zsh/themes/jeeef.zsh-theme $HOME/.jvim/backups/.oh-my-zsh/themes/jeeef.zsh-theme > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/jeeef.zsh-theme $HOME/.oh-my-zsh/themes/jeeef.zsh-theme

  echo "Backing up and symlinking .ctags ..."
  cp $HOME/.ctags $HOME/.jvim/backups/.ctags > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.ctags $HOME/.ctags

  echo "Backing up and symlinking .ackrc ..."
  cp $HOME/.ackrc $HOME/.jvim/backups/.ackrc > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/.ackrc $HOME/.ackrc

  echo "Backing up and symlinking garybernhart/dotfiles binaries to $HOME/bin ..."
  mkdir -p $HOME/bin
  ln -sf $HOME/.jvim/bonus/garys-dotfiles/bin/* $HOME/bin

  echo "Backing up and symlinking .githelpers ..."
  cp $HOME/.githelpers $HOME/.jvim/backups/.githelpers > /dev/null 2>&1
  ln -sf $HOME/.jvim/bonus/garys-dotfiles/.githelpers $HOME/.githelpers
fi

echo "Installation complete"
