{ self, ... }@inputs:
{ config, lib, pkgs, ... }: {
  # https://github.com/NobbZ/nixos-config/blob/overhaul/flake.nix
  # https://github.com/nix-community/home-manager/issues/1519
  #
  imports = [ inputs.nix-doom-emacs.hmModule ];
  nixpkgs = {
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
    };
    overlays = [
      inputs.nix-hls.overlay
      inputs.emacs-overlay.overlay
      inputs.nix-colmena.overlay
    ];
  };
  fonts = { fontconfig.enable = true; };
  home = {
    stateVersion = "22.05";
    packages = with pkgs; [
      # fonts start
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      input-fonts
      # fonts end
      ack
      ag
      file
      gcc
      htop
      lm_sensors
      nix
      nixfmt
      nix-prefetch-scripts
      pinentry_curses
      python39Full
      python39Packages.youtube-dl-light
      python39Packages.python-lsp-server
      ripgrep
      rnix-lsp
      rxvt-unicode
      tmux
      tree
      xclip
    ];
  };
  services.gpg-agent = {
    enable = true;
    # defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    # emacsPackage = pkgs.emacsGcc;
    # emacsPackagesOverlay = inputs.emacs-overlay.overlay;
  };
}
