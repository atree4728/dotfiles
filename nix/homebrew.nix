{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    taps =
      map
        (name: {
          inherit name;
          trusted = true;
        })
        [
          "abue-ammar/tinycast"
          "felixkratz/formulae"
          "laishulu/homebrew"
          "nikitabobko/tap"
          "riscv-software-src/riscv"
          "unisonweb/unison"
        ];

    brews = [
      "cmake"
      "felixkratz/formulae/borders"
      "fish"
      "gcc"
      "laishulu/homebrew/macism"
      "llvm"
      "make"
      "opam"
      "podman"
      "riscv-software-src/riscv/riscv-tools"
      "unisonweb/unison/unison-language"
      "zlib"
      "zsh"
    ];

    casks = [
      "1password"
      "1password-cli"
      "abue-ammar/tinycast/tinycast"
      "anki"
      "arc"
      "discord"
      "font-biz-udgothic"
      "font-biz-udmincho"
      "font-consolas-for-powerline"
      "font-fira-code-nerd-font"
      "font-harano-aji"
      "font-ibm-plex-mono"
      "font-ibm-plex-sans"
      "font-ibm-plex-sans-jp"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "font-latin-modern"
      "font-m-plus-2"
      "font-new-computer-modern"
      "font-noto-sans"
      "font-noto-sans-cjk"
      "font-noto-sans-jp"
      "font-noto-serif-cjk"
      "font-plemol-jp-nf"
      "font-tex-gyre-heros"
      "font-udev-gothic-nf"
      "gcloud-cli"
      "ghostty"
      "google-chrome"
      "guitar-pro"
      "karabiner-elements"
      "keybase"
      "macskk"
      "mactex-no-gui"
      "monitorcontrol"
      "musescore"
      "ngrok"
      "nikitabobko/tap/aerospace"
      "obs"
      "obsidian"
      "orbstack"
      "quarto"
      "slack"
      "spotify"
      "steam"
      "visual-studio-code"
      "zen"
      "zoom"
      "zotero"
    ];
  };
}
