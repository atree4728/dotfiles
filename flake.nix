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
    # No `follows`: upstream builds and tests against its own nixpkgs pin.
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      determinate,
      llm-agents,
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
          ./nix/homebrew.nix
          home-manager.darwinModules.home-manager
          {
            system.primaryUser = username;
            users.users.${username}.home = "/Users/${username}";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit llm-agents; };
              users.${username} = ./nix/home.nix;
            };
          }
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
