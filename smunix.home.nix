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
      arc-icon-theme
      binutils
      bluezFull
      ccls
      citrix_workspace
      colmena
      conky
      direnv
      dos2unix
      eclipses.eclipse-cpp
      evince
      feh
      ffmpeg
      file
      fish
      git
      gcc
      gimp
      gmic
      gimpPlugins.gmic
      ghcid
      google-chrome-dev
      # inputs.nix-hls.packages.x86_64-linux.haskell-language-server-8107
      haskell-language-server
      haskellPackages.cabal-install
      haskellPackages.fourmolu
      haskellPackages.hasktags
      haskellPackages.hoogle
      haskellPackages.implicit-hie
      haskell.compiler.ghc8107
      # haskell.compiler.ghc902
      haskellPackages.fourmolu
      hddtemp
      hpack
      htop
      imagemagick
      irony-server
      jq
      lm_sensors
      lorri
      lsb-release
      mplayer
      nix
      nixfmt
      nix-prefetch-scripts
      networkmanagerapplet
      nodejs
      obs-studio
      ormolu
      pasystray
      pciutils
      pinentry_curses
      pmount
      python39Full
      python39Packages.youtube-dl-light
      python39Packages.python-lsp-server
      ripgrep
      rnix-lsp
      rxvt-unicode
      tmux
      tree
      vlc
      xscreensaver
      xclip
      xdotool
      zoom-us
    ];
  };
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
  # Speed up direnv
  services.lorri.enable = true;
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
    emacsPackage = pkgs.emacsGit;
    # emacsPackagesOverlay = inputs.emacs-overlay.overlay;
  };
}
