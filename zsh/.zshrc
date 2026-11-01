# ~/.zshrc — fast macOS shell config

export EDITOR="nvim"
export VISUAL="nvim"
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$HOME/.local/bin:/opt/homebrew/bin:$PATH"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt AUTO_CD

# Vim keybindings in shell
bindkey -v
export KEYTIMEOUT=1

# Minimal fast prompt with git branch
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{cyan}%1~%f%F{yellow}${vcs_info_msg_0_}%f %F{green}❯%f '

# Aliases
alias v="nvim"
alias vi="nvim"
alias g="git"
alias gs="git status -sb"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate -n 20"
alias pn="pnpm"
alias lg="lazygit"
alias ll="ls -lahG"

# Fuzzy switch git branch
gsw() {
  local branch
  branch=$(git branch --sort=-committerdate --format="%(refname:short)" | fzf --height 40% --reverse) && git switch "$branch"
}

# Inspect or kill process on a TCP port
port() {
  if [[ -z "$1" ]]; then
    lsof -iTCP -sTCP:LISTEN -P -n
  elif [[ "$1" == "kill" && -n "$2" ]]; then
    lsof -ti tcp:"$2" | xargs kill -9 && echo "Killed port $2"
  else
    lsof -i tcp:"$1" -P -n
  fi
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}
