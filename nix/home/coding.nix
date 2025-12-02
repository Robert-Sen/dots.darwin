{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.coding;
in {
  options.nix-darwin.home.coding = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.nix-darwin.home.enable;
      description = "Whether to enable coding module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      (with pkgs; [
        orbstack
        vscode
        zed-editor
        helix
      ])
      ++ (with pkgs; [
        gcc14
        gdb
        go
        rustup
        nodejs_24
        python314
        typst
        tinymist
        elan

        nodePackages.pnpm
        nodePackages.yarn
      ]);
  };
}
