{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {...}: let
    system = "aarch64-darwin";
    hostname = "Robert-Sens-MacBook-Air";
    username = "robert-sen";

    specialArgs = {
      inherit inputs system hostname username;
    };
  in {
    darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [
        ./system

        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs = {config.allowUnfree = true;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.backupFileExtension = "bak";
          home-manager.users.${username} = import ./home;
        }
      ];
    };

    formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.alejandra;
  };
}
