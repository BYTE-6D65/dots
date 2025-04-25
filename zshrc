# === ENVIRONMENT ===
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. "$HOME/.local/bin/env"

# === SHELL OPTIONS ===
setopt PROMPT_SUBST          # Expand variables in PROMPT
setopt NO_CASE_GLOB          # Case-insensitive path globs
setopt CORRECT               # Auto-correct mistyped commands
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# === HISTORY ===
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS

# === PROMPT CONFIG ===
function parse_git_branch {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -n $branch ]] && echo " ($branch)"
}
function precmd {
  GIT_BRANCH=$(parse_git_branch)
}
PROMPT='%F{magenta}%*%f %(?.%F{cyan}.%F{red})%n@%m%f:%F{green}%~%f%F{yellow}${GIT_BRANCH}%f %# '

# === NAVIGATION ALIASES ===
alias ..='cd ..'
alias ...='cd ../..'
alias //='cd -'

# File listing
alias ls='ls -G'            # Colorized (macOS uses BSD ls)
alias ll='ls -lh'           # Human-readable sizes
alias la='ls -la'           # Show all files
alias lt='ls -lt'           # Sort by mod time

# Safe file ops
alias mv='mv -i'            # Prompt before overwrite
alias cp='cp -i'            # Prompt before overwrite
alias rm='rm -i'            # Prompt before deletion

# Utilities
alias update='brew update && brew upgrade && brew cleanup'

# === GIT UTILITIES ===

# Add GitHub remote with standardized naming convention
function add-gh-remote() {
  local repo_name=$(basename "$(pwd)")
  git remote add gh "https://github.com/byte-6d65/${repo_name}.git"
  echo "➕ Linked GitHub remote: gh → https://github.com/byte-6d65/${repo_name}.git"
}

# dep'd idea keeping for later thought on structuring
#function ghinit() {
#  local repo_name=$(basename "$(pwd)")
#  git init
#  git add .
#  git commit -m "Initial commit"
#  git remote add gh "https://github.com/byte-6d65/${repo_name}.git"
#  git push -u gh main
#  echo "✅ Repo initialized and pushed to GitHub: $repo_name"
#}

# === ZOXIDE (smart jump) ===
eval "$(zoxide init zsh)"

# === AUTOSUGGESTIONS ===
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# === SYNTAX HIGHLIGHTING (must be last) ===
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
