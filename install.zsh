# === Dotfile Classification ===
# .zprofile → one-time login shell (plumbing, environment, dependencies)
# .zshrc    → every interactive shell (UI, toys, keybindings, zoxide, bun)
# .zlogin   → rarely used (post-login hooks)
# .zshenv   → avoid unless portable env vars (loaded even in scripts)
# === install script for dotfiles ===
#!/bin/zsh

# === kernel name check ===
K_name="$(uname -s)"
timestamp=$(date +%Y%m%d-%H%M%S)

case "$K_name" in
  Darwin)
    echo "Darwin detected"
    ;;
  Linux)
    echo "Linux detected"
    ;;
  *)
    echo "Unknown OS, no specific config loaded."
    ;;
esac

# === backup existing dotfiles ===
mkdir -p "$HOME/.zsh_bak"
cp "$HOME/.zshrc" "$HOME/.zsh_bak/zshrc.bak.$timestamp" 2>/dev/null
cp "$HOME/.zprofile" "$HOME/.zsh_bak/zprofile.bak.$timestamp" 2>/dev/null

# === move kernel-specific zshrc ===
case "$K_name" in
  Darwin)
    mv -v zshrc.darwin "$HOME/.zshrc"
    echo "Darwin version of zshrc moved to ~/.zshrc"
    ;;
  Linux)
    mv -v zshrc.linux "$HOME/.zshrc"
    echo "Linux version of zshrc moved to ~/.zshrc"
    ;;
  *)
    echo "Unknown OS, no specific config loaded."
    ;;
esac

# === move zprofile ===
mv -v zprofile "$HOME/.zprofile"