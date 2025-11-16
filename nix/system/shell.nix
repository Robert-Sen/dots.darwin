{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.system.shell;
in {
  options.nix-darwin.system.shell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable shell";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };
    programs.fish = {
      enable = true;
    };
  };
}
