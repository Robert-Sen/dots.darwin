{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.shell;
in {
  options.nix-darwin.home.shell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable shell";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
    programs.fish = {
      enable = false;
    };
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableInteractive = true;
    };
    programs.tmux = {
      enable = true;
    };

    home.packages = with pkgs; [
      fish
      fishPlugins.z
      fishPlugins.autopair
      fishPlugins.plugin-git
      fishPlugins.macos
    ];

    home.file = {
      ".config/fish/config.fish" = {
        source = ../config/fish/config.fish;
        force = true;
        mutable = true;
      };
    };
  };
}
