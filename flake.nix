{
  description = "atree's macOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      determinate,
      ...
    }:
    let
      system = "aarch64-darwin";
      hostname = "Ree";
      username = "atree";
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          determinate.darwinModules.default
          { nixpkgs.hostPlatform = system; }
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            users.users.${username}.home = "/Users/${username}";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username} = ./nix/home.nix;
            };
          }
        ];
      };
    };
}
