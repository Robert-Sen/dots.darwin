{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.menubar;
in {
  options.nix-darwin.home.menubar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable util module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ice-bar
    ];
    programs.sketchybar = {
        enable = true;
        service.enable = true;
    };
  };
}
