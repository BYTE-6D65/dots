# bun path add
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. "$HOME/.local/bin/env"

# File navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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

# Enable shell-style substitutions in PROMPT
setopt PROMPT_SUBST

# Git-aware prompt function
function parse_git_branch {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $branch ]]; then
    echo " ($branch)"
  fi
}

# Update Git branch before each prompt
function precmd {
  GIT_BRANCH=$(parse_git_branch)
}

# Final prompt string (with time, status color, git branch)
PROMPT='%F{magenta}%*%f %(?.%F{cyan}.%F{red})%n@%m%f:%F{green}%~%f%F{yellow}${GIT_BRANCH}%f %# '

# Clean, readable prompt:
#PROMPT='%n@%m:%~ %# '

# Clean autocomplete
autoload -Uz compinit
compinit

# Better history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS

# Autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (must be last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
