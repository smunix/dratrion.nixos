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
      ack
      ag
      file
      gcc
      htop
      lm_sensors
      inputs.nixF.defaultPackage.x86_64-linux
      nixfmt
      nix-prefetch-scripts
      pinentry
      python39Full
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
  programs = {
    #
    # GIT
    #
    git = {
      enable = true;
      userName = "Providence Salumu";
      userEmail = "Providence.Salumu@smunix.com";
      signing.signByDefault = true;
      signing.key = "48288CFA12817D0C5D56733C6E341E460DD3F77C";
      ignores = [
        "*.nogit*"
        ".envrc"
        ".vscode"
        ".vim"
        "Session.vim"
        "dist-newstyle"
        "result"
        "stack.yaml.lock"
        "build"
        "TAGS"
        ".stack-work"
        ".direnv"
      ];
      lfs.enable = true;
      delta.enable = true;
      extraConfig = {
        pull = { rebase = true; };
        fetch = { prune = true; };
        diff = { colorMoved = "zebra"; };
        core = { editor = "emacs -nw"; };
      };
    };
  };
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    # emacsPackage = pkgs.emacsGcc;
    # emacsPackagesOverlay = inputs.emacs-overlay.overlay;
  };
}
