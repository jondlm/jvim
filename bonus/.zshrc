# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zplugs (https://github.com/zplug/zplug)
# You must run `zplug install`
[ -d /opt/homebrew/opt/zplug ]   && export ZPLUG_HOME=/opt/homebrew/opt/zplug
[ -d "$HOME/.zplug" ]            && export ZPLUG_HOME="$HOME/.zplug"
source $ZPLUG_HOME/init.zsh

zplug changyuheng/fz, defer:1
zplug rupa/z, use:z.sh
zplug romkatv/powerlevel10k, as:theme, depth:1
zplug Aloxaf/fzf-tab, use:fzf-tab.plugin.zsh

zplug load

# Bash completion interop
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

# Zsh settings (mostly select stuff taken from oh-my-zsh)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=20000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data
set -o vi                     # vi mode

# Aliases
alias g='git'
alias ga='git add -A'
alias gb='git branch'
alias gc='git commit -v'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch --all --tags'
alias gff='git fetch --all && git merge --ff-only'
alias github="git remote -v | sed 's/origin.*:\([^.]*\).*/\1/' | head -n1 | read GH; /usr/bin/open \"https://github.com/\$GH\""
alias gl='git pull --ff-only'
alias gm='git fetch origin master:master && git checkout master'
alias gmpt='git fetch origin master-passing-tests:master-passing-tests && git checkout master-passing-tests'
alias gpn='git push -u --no-verify'
alias gprs="git log --pretty=format:%s \`git describe --abbrev=0 --match 'v[0-9]*.[0-9]*.[0-9]*'\`..HEAD | grep 'Merge pull request'"
alias gpush='git push -u'
alias gr='git branch --sort=-committerdate --format "%(refname:lstrip=2)" | fzf | xargs git checkout'
alias gs='git status'
alias gunwip='git log -n 1 | ggrep -qc "\--wip--" && git reset HEAD~1'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

alias conflicts='rg "^(<<<<<<<|>>>>>>>|=======)[^<>=]"'
alias ll='ls -lah'
alias nr='npm run'
alias pk="ps ax | fzf | sed 's/^\s\+//' | cut -d ' ' -f 1 | xargs kill"
alias pk9="ps ax | fzf | sed 's/^\s\+//' | cut -d ' ' -f 1 | xargs kill -9"
alias pks="ps ax | fzf --multi | sed 's/^\s\+//' | cut -d ' ' -f 1 | xargs sudo kill"
alias td='pushd $(mktemp -d)'
alias vim='nvim'

# Mac only aliases
if [ "$(uname)" = "Darwin" ]; then
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
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/usr/local/sbin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/bin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/sbin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.jvim/bonus/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.npm-global/bin"

# Mac only exports
if [ "$(uname)" = "Darwin" ]; then
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Neovim is ma fave
export EDITOR='nvim'

# fzf helpers
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

if [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# python virtual env
if [ -f ~/venv/main/bin/activate ]; then
  source ~/venv/main/bin/activate
fi


# ------------------------------------------------------------------------------
# Language runtimes
# ------------------------------------------------------------------------------

# Setup mise
if [ -f ~/.local/bin/mise ]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
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

# "git co worker"
gcw () {
  git fetch origin "$1"
  git checkout FETCH_HEAD
  git checkout -b "$1"
}

# "git resolve conflicts"
grc () {
  for f in `git diff --name-only --diff-filter=U --relative`; do
    vim "$f"
    echo "Is $f resolved? [yn]"
    read response
    if [[ "$response" = "y" ]]; then
      git add "$f"
    fi

    if [[ "$response" = "n" ]]; then
      echo "Aborting the resolve process"
      return 1
    fi
  done
}

# percentage change
pc () {
  echo "scale=4; ( ($1 - $2) / $1 ) * 100" | bc
}

# Convert mp4 to gif. Requires `ffmpeg` and `imagemagick`
mp4togif() {
  out="$(echo $1 | sed 's/\.mp4$/\.gif/')"
  max_width="650"
  frames_per_second="20"
  ffmpeg -i $1 -vf "scale=min(iw\,$max_width):-1" -r "$frames_per_second" -sws_flags lanczos -f image2pipe -vcodec ppm - \
    | convert -delay 5 -layers Optimize -loop 0 - "$out" &&
  echo "$(tput setaf 2)output file: $out$(tput sgr 0)" &&
  open -a "Google Chrome" "$out"
}


# Mac only utils
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

  # send a little pop notification
  notify() {
    osascript -e "display notification with title \"${1:-Task finished}\""
  }
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Import the 'after' override file if it exists. Used for customizations that
# shouldn't be checked into git
if [ -f "$HOME/.zshrc-after" ]; then
  source $HOME/.zshrc-after
fi
