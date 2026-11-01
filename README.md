# ~/dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Article](https://img.shields.io/badge/Deep_Dive-Read_Post-10b981)](https://www.zaynelovecraft.com/articles/filesystem-first-ai-agent-os-cursor-claude)

My macOS setup: a lightweight Zsh config, a single-file Neovim config, Git that switches commit identity based on the repo's remote URL, and baseline Cursor rules.

> 📖 **How this fits into my setup:** [Filesystem-First AI Agent OS for Cursor and Claude Code](https://www.zaynelovecraft.com/articles/filesystem-first-ai-agent-os-cursor-claude)

```text
.
├── Brewfile                 # CLI tools (ripgrep, fd, fzf, gh, neovim, jq, lazygit, ...)
├── cursor/
│   ├── rules/agent.mdc      # Baseline agent rules (copy into a project's .cursor/rules/)
│   └── settings.json        # Editor settings (copy into Cursor's settings.json)
├── git/
│   ├── .gitconfig           # Switches identity via includeIf hasconfig:remote.*.url
│   └── .gitconfig-personal  # The identity used for matching repos (edit this!)
├── nvim/
│   └── init.lua             # lazy.nvim + telescope + treesitter + oil
├── zsh/
│   └── .zshrc               # Vim keys, git-branch prompt, aliases, helper functions
└── install.sh               # Symlinks everything into $HOME (backs up existing files)
```

## Install

Requires macOS with [Homebrew](https://brew.sh). Neovim plugins install themselves on first launch.

```bash
git clone https://github.com/zaynelovecraft/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**Before running the installer, make it yours:**

1. Put your own name and email in `git/.gitconfig-personal`.
2. In `git/.gitconfig`, change `github.com/zaynelovecraft/**` to your GitHub username.

Then run:

```bash
./install.sh
```

The script:

- symlinks `~/.zshrc`, `~/.config/nvim/init.lua`, `~/.gitconfig`, and `~/.gitconfig-personal`
- moves any existing versions to `~/.dotfiles-backup/<timestamp>/` first, so nothing is lost
- runs `brew bundle` to install the tools in `Brewfile`
- is safe to run again; already-linked files are skipped

Open a new terminal when it finishes. To undo, delete the symlinks and move your files back from `~/.dotfiles-backup/`.

The Cursor files are not linked automatically. Copy `cursor/rules/agent.mdc` into a project's `.cursor/rules/` and merge `cursor/settings.json` into Cursor's settings if you want them.

## Highlights

### Git identity that follows the remote (`git/.gitconfig`)

Git 2.36+ can match on remote URLs in `includeIf`. Any repo whose remote matches `github.com/zaynelovecraft/**` commits with the identity in `.gitconfig-personal`, no matter where it lives on disk. Everything else uses your default identity.

```ini
[includeIf "hasconfig:remote.*.url:https://github.com/zaynelovecraft/**"]
    path = ~/.gitconfig-personal
[includeIf "hasconfig:remote.*.url:git@github.com:zaynelovecraft/**"]
    path = ~/.gitconfig-personal
```

Check which identity a repo will use with `git config user.email` inside it.

### Neovim (`nvim/init.lua`)

One readable file, with plugins managed by [lazy.nvim](https://github.com/folke/lazy.nvim):

| Key | Action |
|-----|--------|
| `<Space>ff` | Find files (telescope) |
| `<Space>fg` | Live grep (telescope + ripgrep) |
| `<Space>fb` | Open buffers |
| `-` | Open the parent directory (oil.nvim) |
| `<C-d>` / `<C-u>` | Half-page scroll, cursor stays centered |
| `J` / `K` (visual) | Move selected lines down / up |

Also: relative line numbers, persistent undo, highlight on yank, and treesitter for TS/TSX, Lua, JSON, Markdown, Bash and Rust.

### Zsh (`zsh/.zshrc`)

No framework. Vim keybindings, a prompt with the current git branch, 50k-line shared history, and a few helpers:

| Command | What it does |
|---------|--------------|
| `port` | List every listening TCP port |
| `port 3000` | Show what's on port 3000 |
| `port kill 3000` | Kill whatever is on port 3000 |
| `gsw` | Fuzzy-switch git branches, most recent first (needs `fzf`) |
| `mkcd <dir>` | Make a directory and `cd` into it |

Aliases: `v`/`vi` → `nvim`, `g` → `git`, `gs`, `gd`, `gl`, `pn` → `pnpm`, `lg` → `lazygit`, `ll`.

## License

MIT
