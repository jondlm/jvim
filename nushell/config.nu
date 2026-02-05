# Nu config
$env.config.edit_mode = "vi" # ftw
$env.config.show_banner = "short" # just startup time
$env.config.filesize.unit = "binary" # 5TB (bad) is actually 4.5TiB (good)
$env.config.completions.algorithm = "fuzzy" # better tab completions

# Environment variables
$env.EDITOR = "nvim"
$env.LANG = "en_US.UTF-8"

if (uname | get kernel-name) == Darwin {
  $env.HOMEBREW_NO_AUTO_UPDATE = 1
  $env.SSH_AUTH_SOCK = (ls /private/tmp/com.apple.launchd.*/Listeners | get name | first)
}

# Variables
let vendor_autoload_dir = ($nu.default-config-dir | path join "vendor/autoload")

$env.PATH = [
  "/usr/local/bin",
  "/opt/homebrew/bin",
  "/usr/local/sbin",
  "/usr/bin",
  "/bin",
  "/usr/sbin",
  "/sbin",
  "/opt/homebrew/opt/postgresql@15/bin",
  ($env.HOME | path join "bin"),
  ($env.HOME | path join ".jvim/bonus/bin"),
  ($env.HOME | path join ".local/bin"),
  ($env.HOME | path join ".cargo/bin"),
  ($env.HOME | path join ".npm-global/bin")
]

if ('GOPATH' in $env) {
  $env.PATH ++= [($env.GOPATH | path join "bin")]
}

# Ensure nu directories exist
mkdir $vendor_autoload_dir
mkdir $nu.cache-dir

# Load 3rd party modules
let tools = [
  { cmd: "zoxide init nushell",              name: "zoxide.nu" },
  { cmd: "starship init nu",                 name: "starship.nu" },
  { cmd: "atuin init nu --disable-up-arrow", name: "atuin.nu" },
  { cmd: "carapace _carapace nushell",       name: "carapace.nu" },
  { cmd: "mise activate nu",                 name: "mise.nu" }
]

for tool in $tools {
  let path = ($vendor_autoload_dir | path join $tool.name)
  # Only generate the file if it doesn't exist. To force an update, just
  # delete the files in vendor/autoload.
  if not ($path | path exists) {
    run-external ...(echo $tool.cmd | split row " ")
      | save -f $path
  }
}

# Aliases & Functions
## Git
alias ga = git add -A
alias gc = git commit -v
alias gco = git checkout
alias gd = git diff
alias gf = git fetch --all --tags
alias gl = git pull
alias gpush = git push -u
alias gs = git status
## General
alias vim = nvim
alias r = bin/rails

### Fuzzy checkout an old branch
def gr [] {
  git branch --sort=-committerdate --format "%(refname:lstrip=2)"
  | fzf
  | xargs git checkout
}

### Manually resolve git conflicts
def grc [] {
    let conflicts = (
        git diff --name-only --diff-filter=U --relative
        | lines
    )

    if ($conflicts | is-empty) {
        print "No conflicts found."
        return
    }

    for file in $conflicts {
        nvim $file

        let response = (input $"Is ($file) resolved? [y/n]: ")

        if $response == "y" {
            ^git add $file
        } else if $response == "n" {
            print "Aborting the resolve process"
            return # Exits the function immediately
        }
    }
}

### Create a WIP commit (bypassing hooks and signing)
def gwip [] {
    git add -A
    # Remove deleted files from index
    let deleted_files = (git ls-files --deleted | lines)
    if not ($deleted_files | is-empty) {
        git rm ...$deleted_files
    }
    git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"
}

### Undo the last commit if it's a WIP commit
def gunwip [] {
    let last_commit = (git log -n 1 --format=%B)
    if ($last_commit | str contains "--wip--") {
        git reset HEAD~1
    } else {
        print "Last commit is not a WIP commit"
    }
}

## Processes
### Kill a process
def pk [] {
  ps
  | select pid name
  | input list -f
  | kill $in.pid
}

## Directories
alias td = cd (mktemp -d)
