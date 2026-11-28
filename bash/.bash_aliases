# Personal aliases — loaded from ~/.bashrc after Omarchy defaults

alias ,cl='clear'
alias ,c='claude'   # overrides Omarchy's c='opencode --auto'
alias ,e='exit'
# Kill tmux sessions 1-4. Detached (setsid / nohup on macOS) so the loop survives
# killing the session it was typed in (otherwise it dies after the first kill).
if command -v setsid >/dev/null; then
  alias ,tko='setsid -f bash -c '\''for s in 1 2 3 4; do tmux kill-session -t "=$s"; done'\'' >/dev/null 2>&1'
else
  alias ,tko='nohup bash -c '\''for s in 1 2 3 4; do tmux kill-session -t "=$s"; done'\'' >/dev/null 2>&1 &'
fi

# Restow every dotfiles package (install.sh skips keyd/plymouth; install_macos.sh
# also skips the Linux/Omarchy-only packages and doesn't touch Homebrew with --stow-only).
if [[ $OSTYPE == darwin* ]]; then
  alias ,dot='~/Work/dotfiles/install_macos.sh --stow-only'
else
  alias ,dot='~/Work/dotfiles/install.sh'
fi

alias ,lg='lazygit'
alias ,gs='git status'
alias ,gco='git checkout'
alias gco='git checkout'
alias ,g='git status'

if [[ $OSTYPE != darwin* ]]; then
  alias ,wifi='wifi'   # fzf Wi-Fi picker (~/.local/bin/wifi)
  alias ,battery='battery'   # battery saver: on|off|status (~/.local/bin/battery)
fi
alias ,pr='mkpr'   # open a PR with a Claude-written title/description (~/.local/bin/mkpr)
alias ,pd='pdrive'   # fzf Proton Drive browser (~/.local/bin/pdrive)
