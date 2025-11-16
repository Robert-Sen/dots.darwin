{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.system.sketchybar;
in {
  options.nix-darwin.system.sketchybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable sketchybar";
    };
  };

  config = lib.mkIf cfg.enable {
    services.sketchybar = {
      enable = true;
    };
  };
}
