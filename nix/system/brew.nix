{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.system.brew;
in {
  options.nix-darwin.system.brew = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable system brew module";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [
        "font-noto-sans-sc"
        "font-noto-serif-sc"
        "lulu"
      ];
    };
  };
}
