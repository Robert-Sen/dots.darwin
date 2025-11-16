{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.neovim;
in {
  options.nix-darwin.home.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable neovim module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
    };
    programs.neovim = {
      enable = true;
    };
  };
}
