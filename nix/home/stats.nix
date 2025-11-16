{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.stats;
in {
  options.nix-darwin.home.stats = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable util module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      stats
      htop
      btop
    ];
  };
}
