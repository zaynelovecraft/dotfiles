# ~/dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Article](https://img.shields.io/badge/Deep_Dive-Read_Post-10b981)](https://www.zaynelovecraft.com/articles/filesystem-first-ai-agent-os-cursor-claude)

Opinionated macOS environment — fast Zsh startup, single-file Neovim config, automatic per-remote Git identity switching, and Cursor agent defaults.

> 📖 **Read the full setup breakdown:** [Filesystem-First AI Agent OS for Cursor and Claude Code](https://www.zaynelovecraft.com/articles/filesystem-first-ai-agent-os-cursor-claude)

```text
.
├── Brewfile                 # CLI tools & casks (ripgrep, fd, fzf, gh, neovim, jq)
├── cursor/
│   ├── rules/agent.mdc      # Baseline agent rules (no fluff, prefer rg, lint+build validation)
│   └── settings.json        # Minimal dark editor config
├── git/
│   ├── .gitconfig           # Auto-switches identity via includeIf hasconfig:remote.*.url
│   └── .gitconfig-personal  # Personal GitHub noreply identity
├── nvim/
│   └── init.lua             # Single-file Neovim setup (lazy.nvim, telescope, treesitter, oil)
├── zsh/
│   └── .zshrc               # Sub-30ms shell startup, port/git/pnpm helpers
└── install.sh               # Symlink bootstrapper
```

## Highlights

### 1. Zero-thought multi-account Git (`git/.gitconfig`)

Git 2.36+ supports matching remote URLs directly in `includeIf`. No need to separate folders by work vs. personal — any repo whose remote matches `github.com/zaynelovecraft/**` automatically commits with my personal noreply identity, regardless of where it lives on disk:

```ini
[includeIf "hasconfig:remote.*.url:https://github.com/zaynelovecraft/**"]
    path = ~/.gitconfig-personal
[includeIf "hasconfig:remote.*.url:git@github.com:zaynelovecraft/**"]
    path = ~/.gitconfig-personal
```

### 2. Single-file Neovim (`nvim/init.lua`)

No 40-file Lua labyrinth. Everything lives in one readable `init.lua`:
- Leader = `<Space>`, `<Space>ff` files, `<Space>fg` live grep (`ripgrep`), `-` parent directory via `oil.nvim`
- Built-in LSP (`ts_ls`, `lua_ls`, `rust_analyzer`) + `conform.nvim` format-on-save
- Centered scroll (`<C-d>zz` / `<C-u>zz`), yank-highlight, persistent undo

### 3. Fast Zsh (`zsh/.zshrc`)

No Oh-My-Zsh plugin bloat. Pure prompt + `fzf` history + practical shell functions:
- `port <num>` — inspect or kill whatever is holding a local port
- `gsw` — fuzzy checkout recent Git branches via `fzf`
- `mkcd <dir>` — create and enter directory in one shot

## Quick Start

```bash
git clone https://github.com/zaynelovecraft/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```
