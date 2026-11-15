# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# Rust toolchain
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them below)
source "$OMARCHY_PATH/default/bash/rc"

# Personal aliases (sourced after Omarchy so they take precedence)
[[ -r "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# Live reload: `reload-shells` (Super+Alt+R) bumps a stamp file; each shell
# re-sources its aliases at the next prompt when the stamp is newer than its last load.
__reload_stamp="${XDG_STATE_HOME:-$HOME/.local/state}/bash-reload.stamp"
__reload_loaded=$EPOCHSECONDS
__reload_check() {
  [[ -e $__reload_stamp ]] || return
  local mtime
  mtime=$(stat -c %Y "$__reload_stamp") || return
  if (( mtime >= __reload_loaded )) && [[ $mtime != "$__reload_seen" ]]; then
    __reload_seen=$mtime
    __reload_loaded=$EPOCHSECONDS
    [[ -r "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
  fi
}
PROMPT_COMMAND+=(__reload_check)
