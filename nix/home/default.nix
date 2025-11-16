{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.nix-darwin.home;
in {
  imports = [
    ./basic.nix
    ./coding.nix
    ./core.nix
    ./lang.nix
    ./menubar.nix
    ./mutable.nix
    ./neovim.nix
    ./shell.nix
    ./stats.nix
    ./terminal.nix
    ./util.nix
  ];

  options.nix-darwin.home = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable home";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      username = username;
      homeDirectory = "/Users/${username}";

      stateVersion = "25.11";
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "Robert-Sen";
        user.email = "lihua19832@163.com";
      };
    };

    home.packages = with pkgs; [];
    programs.home-manager.enable = true;
  };
}
