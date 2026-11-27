#!/usr/bin/env bash
# Stow every package in this repo into $HOME (target comes from .stowrc).
#
#   ./install.sh              restow all packages
#   ./install.sh bash nvim    restow only these
#   ./install.sh -n           dry run: show what would change
#
# keyd and plymouth are skipped (they're installed as root, not symlinked; see README).
# A package that conflicts with a real file is reported and skipped, so one
# conflict doesn't stop the rest.
set -uo pipefail

cd "$(dirname "$(readlink -f "$0")")"

dry=()
if [[ ${1:-} == -n || ${1:-} == --dry-run ]]; then
  dry=(-n)
  shift
fi

skip=(keyd plymouth)

if (($#)); then
  packages=("$@")
else
  packages=()
  for d in */; do
    d=${d%/}
    [[ " ${skip[*]} " == *" $d "* ]] && continue
    packages+=("$d")
  done
fi

# Directories that must stay real so stow links their contents instead of
# replacing the whole directory with one symlink.
#   nvim/lua/plugins  — Omarchy drops its theme.lua symlink in here
#   omarchy/themes    — themes from `omarchy theme install` stay out of the repo
#   omarchy/plugins   — plugins from `omarchy plugin add` stay out of the repo
keep_real=(
  "$HOME/.config/nvim/lua/plugins"
  "$HOME/.config/omarchy/themes"
  "$HOME/.config/omarchy/plugins"
)
((${#dry[@]})) || mkdir -p "${keep_real[@]}"

ok=() failed=()
for p in "${packages[@]}"; do
  if [[ ! -d $p ]]; then
    echo "!! $p: no such package" >&2
    failed+=("$p")
    continue
  fi
  # Restow for real; a dry run uses plain stow so it lists only new links.
  if ((${#dry[@]})); then mode=(-n -v); else mode=(-R); fi
  if out=$(stow "${mode[@]}" "$p" 2>&1); then
    ok+=("$p")
    [[ -n ${dry[*]} ]] && grep -v 'simulation mode' <<<"$out" | sed "s/^/   $p: /"
  else
    echo "!! $p:" >&2
    sed 's/^/   /' <<<"$out" >&2
    failed+=("$p")
  fi
done

echo
echo "stowed:  ${ok[*]:-none}${dry:+ (dry run)}"
((${#failed[@]})) && echo "failed:  ${failed[*]}"
echo "Run 'reload-shells' (or open a new terminal) to pick up bash changes."
((${#failed[@]} == 0))
