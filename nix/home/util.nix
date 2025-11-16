{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.util;
in {
  options.nix-darwin.home.util = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable util module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      yazi
      lazygit
    ];
  };
}
