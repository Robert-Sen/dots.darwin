{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.terminal;
in {
  options.nix-darwin.home.terminal = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable kitty";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      iterm2
      kitty
    ];
    programs.kitty = {
      enable = false;
      enableGitIntegration = true;
    };

    home.file = {
      ".config/kitty/kitty.conf" = {
        source = ../config/kitty/kitty.conf;
        force = true;
        mutable = true;
      };
    };
  };
}
