{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix-darwin.system.desktop;
in
{
  options.nix-darwin.system.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable nix-darwin system desktop module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty
    ];
  };
}
