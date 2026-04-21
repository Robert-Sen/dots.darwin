{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix-darwin.system.common;
in
{
  options.nix-darwin.system.common = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable nix-darwin system common module";
    };
  };

  config = lib.mkIf cfg.enable {
    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [
      # core
      coreutils
      wget
      curl
      ripgrep   # alternative to find
      fd        # alternative to grep
      tree
      bat
      openssh
      git
      vim

      # cli
      zsh
      fish
      fishPlugins.z
      fishPlugins.macos
      fishPlugins.autopair
      starship
      fzf
      neovim
      yazi
      tmux
      lazygit
      lazydocker
      codex
      opencode

      # other utils
      jq
      yq
      btop
      htop
      fastfetch
      gh        # github cli

      # nix related
      # direnv
      nix-direnv
      nix-prefetch
      nixfmt-tree # default nix formatter

      # langs
      gcc14
      go
      rustup
      nodejs_25
      python314
      typst
      tinymist
      elan
      nil
      pnpm
      yarn
    ];
  };
}
