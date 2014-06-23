ln -sf $HOME/.jvim/.vimrc $HOME/.vimrc

# Bonus

if [ "$1" = "bonus" ] ; then
  ln -sf $HOME/.jvim/bonus/.tmux.conf $HOME/.tmux.conf
  ln -sf $HOME/.jvim/bonus/.zshrc $HOME/.zshrc
  ln -sf $HOME/.jvim/bonus/.ctags $HOME/.ctags
  ln -sf $HOME/.jvim/bonus/.ackrc $HOME/.ackrc
fi

