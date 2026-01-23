{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix-darwin.home.nix;
in
{
  options.nix-darwin.home.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.nix-darwin.home.enable;
      description = "Whether to enable home nix module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-prefetch
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
