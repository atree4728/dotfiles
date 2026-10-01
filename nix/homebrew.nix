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
          "felixkratz/formulae"
          "laishulu/homebrew"
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
  };
}
