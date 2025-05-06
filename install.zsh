#!/bin/zsh
# === Dotfile Classification ===
# .zprofile → one-time login shell (plumbing, environment, dependencies)
# .zshrc    → every interactive shell (UI, toys, keybindings, zoxide, bun)
# .zlogin   → rarely used (post-login hooks)
# .zshenv   → avoid unless portable env vars (loaded even in scripts)
# === install script for dotfiles ===

# === kernel name check ===
K_name="$(uname -s)"
timestamp=$(date +%Y%m%d-%H%M)

# === emoji support detection ===
if [[ $(locale charmap) == "UTF-8" ]]; then
  emoji_ok=1
else
  emoji_ok=0
fi

if (( emoji_ok )); then
  banner_start="🌟🌟🌟"
  banner_end="🌟🌟🌟"
else
  banner_start="###"
  banner_end="###"
fi

echo "$banner_start Starting dotfile installation... $banner_end"

case "$K_name" in
  Darwin)
    echo "$banner_start Darwin detected $banner_end"
    ;;
  Linux)
    echo "$banner_start Linux detected $banner_end"
    ;;
  *)
    echo "$banner_start Unknown OS, no specific config loaded. $banner_end"
    ;;
esac

# === backup existing dotfiles ===
echo "$banner_start Backing up current dotfiles $banner_end"
mkdir -p "$HOME/.zsh_bak"
cp -v "$HOME/.zshrc" "$HOME/.zsh_bak/zshrc.bak.$timestamp" 2>/dev/null
cp -v "$HOME/.zprofile" "$HOME/.zsh_bak/zprofile.bak.$timestamp" 2>/dev/null

# === move kernel-specific zshrc ===
case "$K_name" in
  Darwin)
    mv -v zshrc.darwin "$HOME/.zshrc"
    echo "$banner_start Darwin zshrc installed to ~/.zshrc $banner_end"
    mv -v zprofile.darwin "$HOME/.zprofile"
    echo "$banner_start Darwin zprofile installed to ~/.zprofile $banner_end"
    ;;
  Linux)
    mv -v zshrc.linux "$HOME/.zshrc"
    echo "$banner_start Linux zshrc installed to ~/.zshrc $banner_end"
    ;;
  *)
    echo "$banner_start Unknown OS, no specific config moved. $banner_end"
    ;;
esac

# === source new zshrc ===
echo "$banner_start Sourcing new ~/.zshrc $banner_end"
source "$HOME/.zshrc"

echo "$banner_start Dotfile installation complete. $banner_end"
