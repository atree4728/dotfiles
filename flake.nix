{
  description = "atree's macOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  };

  outputs =
    {
      nix-darwin,
      determinate,
      ...
    }:
    let
      system = "aarch64-darwin";
      hostname = "Ree";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          determinate.darwinModules.default
          { nixpkgs.hostPlatform = system; }
          ./nix/darwin.nix
        ];
      };
    };
}
