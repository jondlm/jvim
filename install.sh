# This code is to determine what directory this script is being run from
LSOF=$(lsof -p $$ | grep -E "/"$(basename $0)"$")
MY_PATH=$(echo $LSOF | sed -r s/'^([^\/]+)\/'/'\/'/1 2>/dev/null)
if [ $? -ne 0 ]; then
  # OSX
  MY_PATH=$(echo $LSOF | sed -E s/'^([^\/]+)\/'/'\/'/1 2>/dev/null)
fi
DIR=$(dirname $MY_PATH)

# Install vundle
mkdir -p $HOME/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Link up .vimrc
ln -sf $DIR/.vimrc $HOME/.vimrc

# Bonus

if [ "$1" = "bonus" ] ; then
  ln -sf $DIR/bonus/.tmux.conf $HOME/.tmux.conf
  ln -sf $DIR/bonus/.zshrc $HOME/.zshrc
  ln -sf $DIR/bonus/.ctags $HOME/.ctags
  ln -sf $DIR/bonus/.ackrc $HOME/.ackrc
fi

