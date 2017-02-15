# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Load my custom zsh theme
# Look in ~/.oh-my-zsh/themes/ for more options
ZSH_THEME="jeeef"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx)

source $ZSH/oh-my-zsh.sh

# Aliases
alias ll='ls -lah'
alias grepp='ps -ef | grep $1'
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -v'
alias gprs="git log --pretty=format:%s \`git tag --sort=version:refname | tail -r | sed -n '1p'\`..HEAD | grep 'Merge pull request'"
alias gpush='git push -u'
alias gpull='git pull'
alias gf='git fetch --all'
alias gff='git fetch --all && git merge --ff-only'
alias gn="git remote -v | sed 's/origin.*:\([^.]*\).*/\1/' | head -n1 | read GH; /usr/bin/open -a \"/Applications/Google Chrome.app\" \"https://github.com/\$GH/network\""
alias c='clear'
alias hbui='cd ~/dev/appnexus/hbui/'
alias an='cd ~/dev/appnexus/'
alias bus='node ~/dev/busseur/index.js'
alias conflicts='ag "^(<<<<<<<|>>>>>>>|=======)[^<>=]"'
alias pk="ps ax | fzf | sed 's/^\s\+//' | cut -d ' ' -f 1 | xargs kill"
alias nr='npm run'
alias vim='nvim'

# Mac only aliases
if [ "`uname`" = "Darwin" ]; then
  alias cut='gcut'
  alias date='gdate'
  alias grep='ggrep'
  alias sed='gsed'
  alias sort='gsort'
  alias readlink='greadlink'
fi

# Golang shiz
export GOPATH=$HOME/go

# PATH configuration
export PATH="/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/bin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/sbin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"

# Setup brew paths if it exists
if hash brew 2>/dev/null; then
  export PATH=$(brew --prefix ruby)/bin:$PATH
fi

# Setup rbenv if it exists
if hash rbenv 2>/dev/null; then
  eval "$(rbenv init -)"
fi

# Setup docker-machine if it exists
if hash docker-machine 2>/dev/null; then
  eval "$(docker-machine env an-vm 2>/dev/null)"
fi

# Uber vi mode
set -o vi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Vim is the best editor
export EDITOR='nvim'

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# added by travis gem
[ -f /Users/jdelamotte/.travis/travis.sh ] && source /Users/jdelamotte/.travis/travis.sh

# fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

# Import the 'after' override file if it exists
if [ -f "$HOME/.zshrc-after" ]; then
  source $HOME/.zshrc-after
fi

