#!/bin/bash
# macOS setup: install the tools these dotfiles use (Homebrew + Proton Drive
# CLI), then stow the packages that make sense off Linux.
#
#   ./install_macos.sh               install tools, then restow
#   ./install_macos.sh --stow-only   just restow (what `,dot` runs)
#   ./install_macos.sh bash nvim     only these packages
#   ./install_macos.sh -n            dry run: show what stow would link
#
# Skipped on macOS: keyd and plymouth (Linux root-installed), hypr,
# omarchy-lock and omarchy-themes (Omarchy only), and the Linux-only scripts in
# bin (battery, wifi, plymouth-ghost, mem, ports — NetworkManager, /proc, pacman…).
#
# Written for the stock /bin/bash 3.2, since Homebrew's bash may not exist yet.
set -uo pipefail

cd "$(dirname "$0")" || exit 1

[[ $(uname -s) == Darwin ]] || { echo "install_macos.sh: this is for macOS; use ./install.sh" >&2; exit 1; }

dry=() stow_only=0 packages=()
while (($#)); do
  case $1 in
    -n | --dry-run) dry=(-n) ;;
    --stow-only) stow_only=1 ;;
    -h | --help) sed -n '2,15s/^# \{0,1\}//p' "$0"; exit 0 ;;
    -*) echo "install_macos.sh: unknown option $1" >&2; exit 1 ;;
    *) packages+=("$1") ;;
  esac
  shift
done

skip=(keyd plymouth hypr omarchy-lock omarchy-themes)
bin_skip='(battery|wifi|plymouth-ghost|mem|ports)'

say() { printf '\033[1;34m::\033[0m %s\n' "$*"; }

# --- tools -------------------------------------------------------------------

brew_formulae=(
  bash bash-completion@2 # bash 5: the scripts use mapfile, ${x,,}, assoc arrays
  stow git gh lazygit
  neovim tmux starship yazi zoxide
  fzf jq fd bat ripgrep
  node # Mason / LSPs in nvim
)
brew_casks=(ghostty font-terminess-ttf-nerd-font)

# Official Proton Drive CLI — used by `pdrive` (the fzf browser in bin/), the
# macOS stand-in for /usr/bin/jdf-pdrive, which is an Arch package.
# Checksums from https://proton.me/download/drive/cli/version.json
PD_VERSION=0.9.0
PD_SHA512_arm64=3f4125de5e41dcc7f4e0e07e8d60737aa18f35c6ecc1ba3fce47ea97b331857eefaf88e74671135af57122d4cb5439b817ec528f8df383550ac7810aeaf0217b
PD_SHA512_x64=a9fc830f38b680ef537fd92db75e1d6e345374f977efa523b145ccc7ec98570756f6ca32378d1bad6a84c9542f24ef43a63c6ec956e5dda9ca731b60b001a6e6

install_brew() {
  if ! command -v brew >/dev/null; then
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [[ -x $b ]] && eval "$("$b" shellenv)" && break
    done
  fi
  if ! command -v brew >/dev/null; then
    echo "Homebrew isn't installed. Install it first (https://brew.sh):" >&2
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' >&2
    exit 1
  fi
  say "brew install ${brew_formulae[*]}"
  brew install "${brew_formulae[@]}"
  say "brew install --cask ${brew_casks[*]}"
  brew install --cask "${brew_casks[@]}"
}

install_proton_drive() {
  local dest=$HOME/.local/bin/proton-drive arch sum url tmp
  if [[ -x $dest ]] && "$dest" --version 2>/dev/null | grep -q "cli-drive@$PD_VERSION"; then
    say "proton-drive $PD_VERSION already installed"
    return
  fi
  case $(uname -m) in
    arm64) arch=arm64 sum=$PD_SHA512_arm64 ;;
    x86_64) arch=x64 sum=$PD_SHA512_x64 ;;
    *) echo "!! proton-drive: unsupported arch $(uname -m)" >&2; return 1 ;;
  esac
  url=https://proton.me/download/drive/cli/$PD_VERSION/darwin-$arch/proton-drive
  say "downloading proton-drive $PD_VERSION ($arch)"
  tmp=$(mktemp "${TMPDIR:-/tmp}/proton-drive.XXXXXX")
  if ! curl -fL --progress-bar -o "$tmp" "$url"; then
    rm -f "$tmp"; echo "!! proton-drive: download failed" >&2; return 1
  fi
  if [[ $(shasum -a 512 "$tmp" | cut -d' ' -f1) != "$sum" ]]; then
    rm -f "$tmp"; echo "!! proton-drive: checksum mismatch, not installed" >&2; return 1
  fi
  mkdir -p "$HOME/.local/bin"
  chmod 755 "$tmp" && mv "$tmp" "$dest"
  say "installed $dest (sign in with: proton-drive auth login)"
}

# macOS login shells (Terminal, tmux) read ~/.bash_profile, not ~/.bashrc.
ensure_bash_profile() {
  local f=$HOME/.bash_profile
  grep -qs '\.bashrc' "$f" && return
  say "making ~/.bash_profile source ~/.bashrc"
  printf '\n[[ -f ~/.bashrc ]] && . ~/.bashrc\n' >>"$f"
}

if ((stow_only == 0 && ${#dry[@]} == 0)); then
  install_brew
  install_proton_drive
  ensure_bash_profile
fi

# --- stow --------------------------------------------------------------------

command -v stow >/dev/null || { echo "stow not found (brew install stow)" >&2; exit 1; }

if ((${#packages[@]} == 0)); then
  for d in */; do
    d=${d%/}
    [[ " ${skip[*]} " == *" $d "* ]] && continue
    packages+=("$d")
  done
fi

# Directories that must stay real (see install.sh for why). ~/.local/bin also
# holds proton-drive, which isn't in the repo.
keep_real=(
  "$HOME/.config/nvim/lua/plugins"
  "$HOME/.config/jdf"
  "$HOME/.local/bin"
)
((${#dry[@]})) || mkdir -p "${keep_real[@]}"

ok=() failed=()
for p in "${packages[@]}"; do
  if [[ ! -d $p ]]; then
    echo "!! $p: no such package" >&2
    failed+=("$p")
    continue
  fi
  if ((${#dry[@]})); then mode=(-n -v); else mode=(-R); fi
  extra=()
  [[ $p == bin ]] && extra=("--ignore=$bin_skip")
  if out=$(stow "${mode[@]}" ${extra[@]+"${extra[@]}"} "$p" 2>&1); then
    ok+=("$p")
    ((${#dry[@]})) && grep -v 'simulation mode' <<<"$out" | sed "s/^/   $p: /"
  else
    echo "!! $p:" >&2
    sed 's/^/   /' <<<"$out" >&2
    failed+=("$p")
  fi
done

echo
echo "stowed:  ${ok[*]:-none}$( ((${#dry[@]})) && echo ' (dry run)')"
((${#failed[@]})) && echo "failed:  ${failed[*]}"

brew_bash=$(command -v brew >/dev/null && echo "$(brew --prefix)/bin/bash")
if [[ -n $brew_bash && -x $brew_bash && $SHELL != "$brew_bash" && $stow_only == 0 ]]; then
  echo
  echo "Your login shell is $SHELL. To use Homebrew's bash (these dotfiles need bash 5):"
  echo "  echo $brew_bash | sudo tee -a /etc/shells && chsh -s $brew_bash"
fi
((${#failed[@]} == 0))
