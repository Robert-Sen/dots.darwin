{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.ai;
in {
  options.nix-darwin.home.ai = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.nix-darwin.home.enable;
      description = "Whether to enable home ai module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      github-copilot-cli
      codex
      claude-code
      gemini-cli-bin
    ];
  };
}
