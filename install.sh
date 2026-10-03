#!/bin/sh
set -e
cd "$(dirname "$0")"

if ! command -v nix >/dev/null; then
  curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# The installer does not enable flakes; the configuration does from the next run on.
nix_flags='nix-command flakes'

case "$(uname)" in
  Darwin)
    # nix-darwin refuses to overwrite the installer's copy.
    if [ -f /etc/nix/nix.conf ] && [ ! -L /etc/nix/nix.conf ]; then
      sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
    fi
    sudo nix --extra-experimental-features "$nix_flags" run --inputs-from . nix-darwin -- switch --flake .#mac
    chsh -s /run/current-system/sw/bin/fish
    ;;
  Linux)
    nix --extra-experimental-features "$nix_flags" run --inputs-from . home-manager -- switch --impure -b hm-backup --flake .#linux
    ;;
  *)
    echo "unsupported OS: $(uname)" >&2
    exit 1
    ;;
esac
