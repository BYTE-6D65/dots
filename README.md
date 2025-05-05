# Dotfiles: ZSH Configuration Restore

This repository provides a portable, cross-platform configuration restore system for Zsh-based environments.

## ✅ Purpose

* Restore `.zshrc` and `.zprofile` from clean, version-controlled sources
* Automatically install platform-specific configurations (`Darwin`, `Linux`)
* Backup existing configs before overwriting

## ⚠️ Expectations

This repo **does not install** Zsh or any external plugins.
Ensure the following are already installed on the system:

* Zsh
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
* [zsh-completions](https://github.com/zsh-users/zsh-completions)
* [zoxide](https://github.com/ajeetdsouza/zoxide), [fastfetch](https://github.com/fastfetch-cli/fastfetch), Bun, etc.

## 🛠 Install Steps (install script is ass rn suggest manual cp of needed file)

```bash
# Clone the repo
cd ~/Projects
git clone https://github.com/byte-6d65/dots.git
cd dots

# Run the install script
./install.zsh
```

This will:

* Detect the kernel type (`Darwin` or `Linux`)
* Backup your current `.zshrc` and `.zprofile` into `~/.zsh_bak/`
* Move the appropriate config (`zshrc.darwin` or `zshrc.linux`) to `~/.zshrc`
* Move `zprofile` to `~/.zprofile`
* Source the new `.zshrc`

## 🌱 Philosophy

This repo treats your shell as a **cleam room not a dumping ground for permenent bandaids**, You should:

* Stay platform scoped, cp the base amd extend for new plat
* Manual install into the '~/.zsh' dir any extentions
* Keep RC files clean, readable
* Understand what gets sourced and when

## 🔧 Plugin Handling Notes

* All plugins are installed manually
* The `_brew` completion file is extracted from the Homebrew install and manually patched into the completions src/ directory.
* The file `zsh-completions.plugin.zsh` is renamed to `zsh-completions.zsh` to align with the plugin loading conventions in this setup.

### 📌 TODO

* Add optional automation to fetch missing plugins and perform the required patching step automatically.

## 🧹 After Install

You may want to:

* Verify your `$PATH`
* Confirm plugin loading succeeded via echoed sourcing lines
* Restart your terminal to test login behavior

---

Built with intent and maintained manually.
