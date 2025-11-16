{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.basic;
in {
  options.nix-darwin.home.basic = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.nix-darwin.home.enable;
      description = "Whether to enable basic module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      google-chrome
      firefox
      qutebrowser
      telegram-desktop
      discord
      slack
      wechat
      obsidian
      spotify
    ];
  };
}
