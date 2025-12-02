{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-darwin.home.shell;
in {
  options.nix-darwin.home.shell = {
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
      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "macos";
          src = pkgs.fishPlugins.macos.src;
        }
      ];
      interactiveShellInit = ''
        fish_vi_key_bindings
        starship init fish | source
        fzf --fish | source

        ls ~/env/*.fish | xargs -I {} bash -c 'source {}'
      '';
      shellAliases = {
        lg = "lazygit";
        ################################
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gst = "git status";

        gb = "git branch";
        gco = "git checkout";

        gl = "git pull";

        gcmsg = "git commit -m";
        gp = "git push";
        gpf = "git push --force";
        ################################
      };
    };
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableInteractive = true;
    };
    programs.tmux = {
      enable = true;
    };
  };
}
