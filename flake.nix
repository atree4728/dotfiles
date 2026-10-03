{
  description = "atree's environment";

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
      username = "atree";
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        modules = [
          determinate.darwinModules.default
          { nixpkgs.hostPlatform = "aarch64-darwin"; }
          ./nix/darwin
          home-manager.darwinModules.home-manager
          {
            system.primaryUser = username;
            users.users.${username}.home = "/Users/${username}";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit llm-agents; };
              users.${username} = ./nix/home;
            };
          }
        ];
      };

      # Needs `--impure`: the user name and the architecture come from the environment.
      homeConfigurations.linux = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
        extraSpecialArgs = { inherit llm-agents; };
        modules = [
          ./nix/home
          {
            home.username = builtins.getEnv "USER";
            home.homeDirectory = builtins.getEnv "HOME";
          }
        ];
      };

      formatter = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ] (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
