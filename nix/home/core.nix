{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.core;
in {
  options.nix-darwin.home.core = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable core";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      coreutils
      ripgrep
      fd
      jq
      bat
      tree
      fastfetch
      fzf
      yazi
      lazygit
    ];
  };
}
