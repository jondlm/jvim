# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Load my custom zsh theme
# Look in ~/.oh-my-zsh/themes/ for more options
ZSH_THEME="jeeef"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx history-substring-search)

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/plugins/history-substring-search/history-substring-search.zsh

# Aliases
alias grep='ggrep' # TODO: only on mac...
alias ll='ls -lah'
alias grepp='ps -ef | grep $1'
alias gs='git status'
alias ga='git add -A'
alias gc='git commit'
alias gpush='git push'
alias gpull='git pull'
alias gf='git fetch --all'
alias gn="git remote -v | sed 's/origin.*:\([^.]*\).*/\1/' | head -n1 | read GH; /usr/bin/open -a \"/Applications/Google Chrome.app\" \"https://github.com/\$GH/network\""
alias c='clear'
alias ph='history | peco'
alias hbui='cd ~/dev/appnexus/hbui/'
alias an='cd ~/dev/appnexus/'
alias bus='node ~/dev/busseur/index.js'

# User configuration
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin"

# Setup brew paths if it exists
if hash brew 2>/dev/null; then
  export PATH=$(brew --prefix ruby)/bin:$PATH
fi

# Setup rbenv if it exists
if hash rbenv 2>/dev/null; then
  eval "$(rbenv init -)"
fi

# Setup boot2docker if it exists
if hash boot2docker 2>/dev/null; then
  $(boot2docker shellinit)
fi

# Uber vi mode
set -o vi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Vim is the best editor
export EDITOR='vim'

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

