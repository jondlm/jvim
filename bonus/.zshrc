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
source $HOME/.zplug/init.zsh

# Zplugs (https://github.com/zplug/zplug)
zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh

# Aliases
alias an='cd ~/dev/appnexus/'
alias bus='node ~/dev/busseur/index.js'
alias conflicts='rg "^(<<<<<<<|>>>>>>>|=======)[^<>=]"'
alias ga='git add -A'
alias gc='git commit -v'
alias gf='git fetch --all --tags'
alias gff='git fetch --all && git merge --ff-only'
alias github="git remote -v | sed 's/origin.*:\([^.]*\).*/\1/' | head -n1 | read GH; /usr/bin/open \"https://github.com/\$GH\""
alias gprs="git log --pretty=format:%s \`git describe --abbrev=0 --match 'v[0-9]*.[0-9]*.[0-9]*'\`..HEAD | grep 'Merge pull request'"
alias gpull='git pull'
alias gpush='git push -u'
alias grepp='ps -ef | grep $1'
alias gs='git status'
alias hbui='cd ~/dev/appnexus/hbui/'
alias ll='ls -lah'
alias notify="osascript -e 'display notification \"Command line task finished\" with title \"Task Finished\"'"
alias nr='npm run'
alias pk="ps ax | fzf | sed 's/^\s\+//' | cut -d ' ' -f 1 | xargs kill"
alias pks="ps ax | fzf --multi | sed 's/^\s\+//' | cut -d ' ' -f 1 | xargs sudo kill"
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
export GO111MODULE=on

# PATH configuration
export PATH="/usr/local/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/bin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/sbin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

# Setup rbenv if it exists
if hash rbenv 2>/dev/null; then
  eval "$(rbenv init -)"
fi

# Uber vi mode
set -o vi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Vim is the best editor
export EDITOR='nvim'

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin"

# Setup asdf
if [ -d ~/.asdf ]; then
  source ~/.asdf/asdf.sh
  source ~/.asdf/completions/asdf.bash
fi

# added by travis gem
[ -f /Users/jdelamotte/.travis/travis.sh ] && source /Users/jdelamotte/.travis/travis.sh

# fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

# ------------------------------------------------------------------------------
# Utility Functions
# ------------------------------------------------------------------------------

# Show the commands ran yesterday
history-yesterday () {
  start=`date -d 'yesterday 00:00' +%s`
  end=`date -d 'today 00:00' +%s`

  sed -E 's/^: //g; s/:0;/\t/g' < ~/.zsh_history | awk -F '\t' "{if (\$1 > $start && \$1 < $end) {print \$2}}"
}


if [ "`uname`" = "Darwin" ]; then
  # capture the stdout of a running process
  capture() {
    sudo dtrace -p "$1" -qn '
      syscall::write*:entry
      /pid == $target && arg0 == 1/ {
        printf("%s", copyinstr(arg1, arg2));
      }
    '
  }
fi



# Load zplugs at the bottom because of some conflict
zplug load

# Import the 'after' override file if it exists
if [ -f "$HOME/.zshrc-after" ]; then
  source $HOME/.zshrc-after
fi
