# Validation Checklist

This project favors explicit verification over narration. Use the checklist below after any install.

## Runtime Behavior

```bash
zsh -lc 'print -r -- $PROMPT'
zsh -lc 'typeset -p PATH'
```

Expected:
- Prompt is set and rendered.
- Brew/Linuxbrew shellenv appears before completions and tool hooks.

## Tool Verification

```bash
zsh -lc 'command -v zoxide; command -v bat; command -v fastfetch'
```

Expected:
- Each tool selected for installation must resolve via `command -v`.

## Alias Safety

```bash
zsh -lc 'alias cat'
```

Expected:
- `cat` aliases to `bat` only when `bat` exists.

## Install Report

```bash
ls -1 ~/.zsh/_BAK/install-report.*.txt | tail -n 1
```

Expected:
- Report contains detections, selections, attempts, and verification results.
