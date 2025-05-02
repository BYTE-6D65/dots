# === Dotfile Classification ===
# .zprofile → one-time login shell (plumbing, environment, dependencies)
# .zshrc    → every interactive shell (UI, toys, keybindings, zoxide, bun)
# .zlogin   → rarely used (post-login hooks)
# .zshenv   → avoid unless portable env vars (loaded even in scripts)
# === install script for dotfiles ===
#!/bin/zsh

# === kernel name check ===
K_name=$(uname -s)
if [[ "$K_name" == "Darwin" ]]; then
  echo "Darwin detected"
elif [[ "$K_name" == "Linux" ]]; then
  echo "Linux detected"
else
  echo "Unknown OS, no specific config loaded."
fi

# === backup existing dotfiles ===
mkdir -p ~/.zsh_bak
cp -v ~/.zshrc ~/.zsh_bak/zshrc.bak 2>/dev/null
cp -v ~/.zprofile ~/.zsh_bak/zprofile.bak 2>/dev/null

# === move new dotfiles to home ===
mv -v zshrc ~/.zshrc
mv -v zprofile ~/.zprofile

# === move kernel-specific dotfile ===
if [[ "$K_name" == "Linux" ]]; then
  mv -v zshrc.linux ~/.zshrc
elif [[ "$K_name" == "Darwin" ]]; then
  mv -v zshrc.darwin ~/.zshrc
else
  echo "Unknown OS, no specific kernel-specific config moved."
fi