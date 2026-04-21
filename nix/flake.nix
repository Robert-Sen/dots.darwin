{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ ... }:
    let
      system = "aarch64-darwin";
      hostname = "Yusukiis-MacBook-Air";
      username = "yusukii";

      specialArgs = {
        inherit
          inputs
          system
          hostname
          username
          ;
      };
    in
    {
      darwinConfigurations."${hostname}" = inputs.nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [
          ./system
        ];
      };

      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
