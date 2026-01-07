# Nu config
$env.config.edit_mode = "vi"          # modal shell editing
$env.config.show_banner = "short"     # only show startup time
$env.config.filesize.unit = "binary"  # 5TB (bad) is actually 4.5TiB (good)

# Environment variables
$env.EDITOR = "nvim"
$env.LANG = "en_US.UTF-8"

if (uname | get kernel-name) == Darwin {
  $env.HOMEBREW_NO_AUTO_UPDATE = 1
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
zoxide init nushell              | save -f ($vendor_autoload_dir | path join "zoxide.nu")    # directory recall
starship init nu                 | save -f ($vendor_autoload_dir | path join "starship.nu")  # better prompt
atuin init nu --disable-up-arrow | save -f ($vendor_autoload_dir | path join "atuin.nu")     # ctrl-r fuzzy history
carapace _carapace nushell       | save -f ($vendor_autoload_dir | path join "carapace.nu")  # built in completions
mise activate nu                                                                             # lang runtime management
  | str replace -a "--ignore-errors" "-o" # prevent deprecation warning
  | save -f ($vendor_autoload_dir | path join "mise.nu")

# Aliases & Functions
## Git
alias ga = git add -A
alias gc = git commit -v
alias gco = git checkout
alias gd = git diff
alias gf = git fetch --all --tags
alias gpush = git push -u
alias gs = git status

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
