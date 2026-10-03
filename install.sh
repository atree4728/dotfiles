#!/bin/sh
set -e
cd "$(dirname "$0")"

if ! command -v nix >/dev/null; then
  curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

case "$(uname)" in
  Darwin)
    # nix-darwin refuses to overwrite the installer's copy, which also drops its flakes setting
    # until nix-darwin writes its own.
    if [ -f /etc/nix/nix.conf ] && [ ! -L /etc/nix/nix.conf ]; then
      sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
    fi
    sudo nix --extra-experimental-features "nix-command flakes" run --inputs-from . nix-darwin -- switch --flake .#mac
    chsh -s /run/current-system/sw/bin/fish
    ;;
  Linux)
    nix run --inputs-from . home-manager -- switch --impure -b hm-backup --flake .#linux
    ;;
  *)
    echo "unsupported OS: $(uname)" >&2
    exit 1
    ;;
esac
