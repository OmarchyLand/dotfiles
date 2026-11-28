# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# macOS: Homebrew on PATH (Apple Silicon, then Intel), plus ~/.local/bin
if [[ $OSTYPE == darwin* ]]; then
  for __brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x $__brew ]] && { eval "$("$__brew" shellenv)"; break; }
  done
  unset __brew
  [[ :$PATH: == *":$HOME/.local/bin:"* ]] || PATH="$HOME/.local/bin:$PATH"
fi

# Rust toolchain
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

if [[ -n ${OMARCHY_PATH:-} && -r $OMARCHY_PATH/default/bash/rc ]]; then
  # All the default Omarchy aliases and functions
  # (don't mess with these directly, just overwrite them below)
  source "$OMARCHY_PATH/default/bash/rc"
else
  # No Omarchy (macOS): the few bits of its rc this setup relies on.
  HISTSIZE=32768 HISTFILESIZE=32768 HISTCONTROL=ignoreboth
  shopt -s histappend checkwinsize
  export EDITOR=nvim
  [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]] && . /opt/homebrew/etc/profile.d/bash_completion.sh
  command -v starship >/dev/null && eval "$(starship init bash)"
  command -v zoxide >/dev/null && eval "$(zoxide init bash)"
  command -v fzf >/dev/null && eval "$(fzf --bash 2>/dev/null)"
  alias ls='ls -G'
fi

# Personal aliases (sourced after Omarchy so they take precedence)
[[ -r "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# Live reload: `reload-shells` (Super+Alt+R) bumps a stamp file; each shell
# re-sources its aliases at the next prompt when the stamp is newer than its last load.
__reload_stamp="${XDG_STATE_HOME:-$HOME/.local/state}/bash-reload.stamp"
__reload_loaded=$EPOCHSECONDS
__reload_check() {
  [[ -e $__reload_stamp ]] || return
  local mtime
  mtime=$(stat -c %Y "$__reload_stamp" 2>/dev/null || stat -f %m "$__reload_stamp") || return
  if (( mtime >= __reload_loaded )) && [[ $mtime != "$__reload_seen" ]]; then
    __reload_seen=$mtime
    __reload_loaded=$EPOCHSECONDS
    [[ -r "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
  fi
}
PROMPT_COMMAND+=(__reload_check)
