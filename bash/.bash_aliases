# Personal aliases — loaded from ~/.bashrc after Omarchy defaults

alias ,cl='clear'
alias ,c='claude'   # overrides Omarchy's c='opencode --auto'
alias ,e='exit'
# Kill tmux sessions 1-4. Detached via setsid so the loop survives killing the
# session it was typed in (otherwise it dies after the first kill).
alias ,tko='setsid -f bash -c '\''for s in 1 2 3 4; do tmux kill-session -t "=$s"; done'\'' >/dev/null 2>&1'

# Restow every dotfiles package (except keyd, which is copied to /etc, not linked).
# One package at a time so a conflict in one doesn't abort the rest.
alias ,dot='(cd ~/Work/dotfiles && mkdir -p ~/.config/nvim/lua/plugins && for p in */; do p=${p%/}; [ "$p" = keyd ] && continue; stow -R "$p" && echo "linked $p"; done)'

alias ,lg='lazygit'
alias ,gs='git status'
alias ,gco='git checkout'
alias gco='git checkout'
alias ,g='git status'

alias ,wifi='wifi'   # fzf Wi-Fi picker (~/.local/bin/wifi)
alias ,battery='battery'   # battery saver: on|off|status (~/.local/bin/battery)
alias ,pr='mkpr'   # open a PR with a Claude-written title/description (~/.local/bin/mkpr)
