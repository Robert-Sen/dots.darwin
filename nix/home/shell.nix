{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix-darwin.home.shell;
in
{
  options.nix-darwin.home.shell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable shell";
    };
  };

  config = lib.mkIf cfg.enable {
    home.shell = {
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
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

        ls ~/env/*.fish | xargs -I {} bash -c 'source {}'
      '';
      shellAliases = {
        lg = "lazygit";
        ldk = "lazydocker";
        ################################
        g = "git";
        glg = "git log";
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
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        ################################
        dk = "docker";
        dkc = "docker compose";
        dkcu = "docker compose up";
        dkcud = "docker compose up -d";
        dkcd = "docker compose down";
        dkn = "docker network";
        dkv = "docker volume";
      };
    };
    programs.starship = {
      enable = true;
      enableInteractive = true;
    };
    programs.fzf = {
      enable = true;
    };
    programs.tmux = {
      enable = true;
    };
  };
}
