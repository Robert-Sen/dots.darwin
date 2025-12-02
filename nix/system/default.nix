{
  inputs,
  system,
  username,
  ...
}: let
  self = inputs.self;
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  imports = [
    ./brew.nix
    ./shell.nix
    ./sketchybar.nix
    ./yabai.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    openssh
    zsh
    vim
    neovim
    alejandra
    raycast
    nix-prefetch
  ];

  system.primaryUser = username;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "${system}";
  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.fish;
  };
}
