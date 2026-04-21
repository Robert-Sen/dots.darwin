{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix-darwin.system.brew;
in
{
  options.nix-darwin.system.brew = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable nix-darwin system brew module";
    };
  };

  config = lib.mkIf cfg.enable {
    homebrew = {
      enable = true;
      brews = [];
      casks = [
        "font-noto-sans-sc"
        "font-noto-serif-sc"
        "jordanbaird-ice"
        "nikitabobko/tap/aerospace"
      ];
    };

    environment.systemPath = [
      "/opt/homebrew/bin"
    ];
  };
}
