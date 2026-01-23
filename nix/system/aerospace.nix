{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix-darwin.system.aerospace;
in
{
  options.nix-darwin.system.aerospace = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable aerospace features";
    };
  };

  config = lib.mkIf cfg.enable {
  };
}
