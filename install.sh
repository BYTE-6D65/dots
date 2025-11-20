#!/bin/sh
# POSIX-compatible dotfiles installer (single-file per OS)

set -u

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

ZSH_BASE="$HOME/.zsh"
PLUGIN_DIR="$ZSH_BASE/plugins"
BACKUP_DIR="$ZSH_BASE/backup"
REPORT_FILE="$BACKUP_DIR/install-report.$TIMESTAMP.txt"

OS_TYPE=$(uname -s 2>/dev/null || echo Unknown)

log() {
  printf '%s\n' "$1"
  printf '%s\n' "$1" >> "$REPORT_FILE"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

ensure_dirs() {
  mkdir -p "$PLUGIN_DIR" "$BACKUP_DIR"
}

backup_file() {
  bf_src="$1"
  if [ -f "$bf_src" ]; then
    bf_base=$(basename "$bf_src")
    cp "$bf_src" "$BACKUP_DIR/${bf_base}.bak.$TIMESTAMP"
    log "Backed up $bf_src to $BACKUP_DIR/${bf_base}.bak.$TIMESTAMP"
  fi
}

ask_os() {
  if [ -t 0 ]; then
    log "OS selection prompt: enter linux/darwin/auto (default: auto)"
    printf '%s [%s] ' "OS? (linux/darwin/auto)" "auto"
    read -r answer
  else
    answer="auto"
  fi

  case "${answer:-auto}" in
    linux|Linux) echo "Linux" ;;
    darwin|Darwin) echo "Darwin" ;;
    auto|AUTO|Auto|"") echo "$OS_TYPE" ;;
    *) echo "$OS_TYPE" ;;
  esac
}

install_plugin() {
  name="$1"
  repo="$2"
  target="$PLUGIN_DIR/$name"

  if [ -d "$target" ]; then
    log "Plugin already present: $name"
    return 0
  fi

  if ! command_exists git; then
    log "ERROR: git not available; cannot install plugin $name"
    return 1
  fi

  log "Cloning plugin $name"
  git clone "$repo" "$target" >/dev/null 2>&1
  if [ -d "$target" ]; then
    log "Installed plugin $name"
    if [ "$name" = "zsh-completions" ] && [ -f "$target/zsh-completions.plugin.zsh" ]; then
      mv "$target/zsh-completions.plugin.zsh" "$target/zsh-completions.zsh"
      log "Normalized zsh-completions plugin filename"
    fi
    return 0
  fi

  log "ERROR: failed to install plugin $name"
  return 1
}

install_zshrc() {
  os="$1"
  zshrc_src=""

  case "$os" in
    Darwin) zshrc_src="$SCRIPT_DIR/dotfiles/zshrc.darwin" ;;
    Linux) zshrc_src="$SCRIPT_DIR/dotfiles/zshrc.linux" ;;
    *) zshrc_src="$SCRIPT_DIR/dotfiles/zshrc.linux" ;;
  esac

  if [ ! -f "$zshrc_src" ]; then
    log "ERROR: missing $zshrc_src"
    return 1
  fi

  backup_file "$HOME/.zshrc"
  cp "$zshrc_src" "$HOME/.zshrc"
  log "Installed ~/.zshrc from $(basename "$zshrc_src")"
}

cleanup_legacy_layout() {
  if [ -d "$ZSH_BASE/dotfiles" ]; then
    mv "$ZSH_BASE/dotfiles" "$BACKUP_DIR/dotfiles.bak.$TIMESTAMP"
    log "Moved legacy $ZSH_BASE/dotfiles to backup"
  fi

  if [ -d "$ZSH_BASE/state" ]; then
    mv "$ZSH_BASE/state" "$BACKUP_DIR/state.bak.$TIMESTAMP"
    log "Moved legacy $ZSH_BASE/state to backup"
  fi
}

main() {
  ensure_dirs
  : > "$REPORT_FILE"

  log "Install report: $REPORT_FILE"
  log "OS detected: $OS_TYPE"
  if command_exists zsh; then
    log "zsh detected"
  else
    log "WARNING: zsh not detected; runtime requires zsh"
  fi

  log ""
  log "Base plugin installation"
  install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
  install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
  install_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions"

  log ""
  log "Next: OS selection (waiting for input if interactive)"
  selected_os=$(ask_os)
  log "Installing ~/.zshrc for $selected_os"
  install_zshrc "$selected_os"
  cleanup_legacy_layout

  log ""
  log "Install complete. Verification status logged above."
  if [ -t 0 ]; then
    log "Tip: run 'source ~/.zshrc' to apply changes in the current shell."
  fi
}

main "$@"
