{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.lang;
in {
  options.nix-darwin.home.lang = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable lang";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc14
      gdb
      go
      rustup
      nodejs_24
      python314
      typst
      tinymist
      elan
    ];
  };
}
