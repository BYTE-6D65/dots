# Dotfiles: Deterministic Zsh Installer

A minimal, auditable Zsh configuration system with a POSIX-compatible installer. Single-file zshrc per OS, no runtime tiers.

## Goals

- Deterministic Zsh runtime behavior
- Explicit, interactive install flow (OS selection)
- Consolidated runtime layout under `~/.zsh/`
- No dynamic mutation of runtime files

## Quick Start

```bash
./install.sh
```

The installer prompts for OS selection:
- `linux`
- `darwin`
- `auto` (default, uses `uname -s`)

Non-interactive runs default to `auto`.

## Directory Layout (Installed)

```
~/.zsh/
├── backup/      # Backups + install reports
└── plugins/     # Zsh plugins
```

`~/.zshrc` is installed directly (no loader).

## What Gets Installed

- Zsh plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-completions
- `~/.zshrc` from this repo:
  - `dotfiles/zshrc.linux`
  - `dotfiles/zshrc.darwin`

## Prompt: Container Tag

When inside a container, the prompt shows a red bracketed tag (e.g. `[ctr]` or `[container-name]`). It prefers `CTR_NAME`, then `/etc/hostname`, then `HOSTNAME`. Detection is based on common Linux container markers (`/.dockerenv`, `/run/.containerenv`, and `/proc/1/cgroup`). Some container runtimes may not expose these markers; in that case the tag will not appear.

## Container Test Notes (Podman)

On some systems (e.g. btrfs), Podman may need the `vfs` storage driver:

```bash
podman run --rm -it --runtime=crun --storage-driver=vfs --root /tmp/podman-root --runroot /tmp/podman-run --network=host \
  -e HOME=/tmp/home -v /path/to/dots:/repo:Z -w /repo ubuntu:24.04 sh
```

To get a persistent container and a stable prompt name:

```bash
podman run --name zsh-test --hostname zsh-test -it --runtime=crun --storage-driver=vfs --root /tmp/podman-root --runroot /tmp/podman-run --network=host \
  -e HOME=/tmp/home -v /path/to/dots:/repo:Z -w /repo ubuntu:24.04 sh
podman --storage-driver=vfs --root /tmp/podman-root --runroot /tmp/podman-run start -ai zsh-test
```

## Reports And Backups

Every install creates a report in `~/.zsh/backup/` with:
- OS detection
- Plugin install results

Backups of prior `~/.zshrc` are stored alongside the report.

## Requirements

- `git` is required to clone plugins.
- Network access is required for plugin clones.

## License

Built with intent and maintained manually.
