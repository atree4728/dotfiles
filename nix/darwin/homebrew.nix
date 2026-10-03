{ config, ... }:
{
  homebrew = {
    enable = true;
    enableFishIntegration = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
      # sudo drops XDG_CONFIG_HOME, so `trusted = true` would otherwise be recorded in
      # ~/.homebrew/trust.json, which brew ignores in a shell that sets XDG_CONFIG_HOME.
      extraEnv.XDG_CONFIG_HOME = "${config.users.users.${config.homebrew.user}.home}/.config";
    };

    taps =
      map
        (name: {
          inherit name;
          trusted = true;
        })
        [
          "abue-ammar/tinycast"
          "nikitabobko/tap"
          "riscv-software-src/riscv"
        ];

    brews = [
      "gcc"
      "llvm"
      "riscv-software-src/riscv/riscv-tools"
    ];

    casks = [
      "1password"
      "1password-cli"
      "abue-ammar/tinycast/tinycast"
      "anki"
      "arc"
      "discord"
      "gcloud-cli"
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

    masApps = {
      Goodnotes = 1444383602;
      Keynote = 409183694;
      Kindle = 302584613;
      LINE = 539883307;
    };
  };
}
