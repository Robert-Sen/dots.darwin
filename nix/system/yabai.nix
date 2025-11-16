{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.system.yabai;
in {
  options.nix-darwin.system.yabai = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable yabai";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.yabai];

    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
    };
  };
}
