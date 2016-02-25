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
alias gpush='git push -u'
alias gpull='git pull'
alias gf='git fetch --all'
alias gff='git fetch --all && git merge --ff-only'
alias gn="git remote -v | sed 's/origin.*:\([^.]*\).*/\1/' | head -n1 | read GH; /usr/bin/open -a \"/Applications/Google Chrome.app\" \"https://github.com/\$GH/network\""
alias c='clear'
alias ph='history | sort -r | peco'
alias phr="history | sort -r | peco | sed 's/^\s\+//' | cut -f 1 -d ' ' --complement | sed 's/^\s\+//' | bash"
alias hbui='cd ~/dev/appnexus/hbui/'
alias an='cd ~/dev/appnexus/'
alias bus='node ~/dev/busseur/index.js'
alias conflicts='ag "^(<<<<<<<|>>>>>>>|=======)[^<>=]"'
alias pk="ps ax | peco | sed 's/^\s\+//' | cut -d ' ' -f 1 | xargs kill"

# Mac only aliases
if [ "`uname`" = "Darwin" ]; then
  alias cut='gcut'
  alias date='gdate'
  alias grep='ggrep'
  alias sed='gsed'
  alias sort='gsort'

  alias phc="history | peco | sed 's/^\s\+//' | cut -f 1 -d ' ' --complement | sed 's/^\s\+\|\s\+$//g' | pbcopy"
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

# History search
bindkey -v
bindkey '^R' history-beginning-search-backward

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
  eval "$(docker-machine env hbui 2>/dev/null)"
fi

# Uber vi mode
set -o vi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Vim is the best editor
export EDITOR='vim'

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Import the 'after' override file if it exists
if [ -f "$HOME/.zshrc-after" ]; then
  source $HOME/.zshrc-after
fi

# Setup nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

