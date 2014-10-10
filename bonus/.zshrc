# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# ZSH_THEME="cloud"
ZSH_THEME="jeeef"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx history-substring-search)

source $ZSH/oh-my-zsh.sh

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

alias vs='cd ~/dev/vendscreen'
alias ym='cd ~/dev/ym'

alias c='clear'
alias ph='history | peco'


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

# Uber vi mode
set -o vi

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export EDITOR='vim'

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
