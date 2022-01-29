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
      # inputs.emacs-overlay.overlay
      inputs.nix-colmena.overlay
      inputs.smunix-nur.overlay
    ];
  };
  fonts = { fontconfig.enable = true; };
  home = {
    stateVersion = "22.05";
    file = {
      "awesome" = {
        source = ./awesome.dratrion;
        # source = ./awesome.moletrooper;
        target = "./.config/awesome";
      };
      # "tmux" = {
      #   source = ./tmux.dratrion;
      #   target = "./.tmux";
      # };
    };
    packages = with pkgs; [
      ack
      ag
      arc-icon-theme
      bat
      binutils
      bluezFull
      bottom
      ccls
      citrix_workspace
      colmena
      conky
      direnv
      dos2unix
      dtrx
      du-dust
      eclipses.eclipse-cpp
      entr
      et
      evince
      fd
      feh
      file
      ffmpeg
      file
      fish
      git
      gcc
      gimp
      gmic
      gimpPlugins.gmic
      ghcid
      git-quick-stats
      google-chrome-dev
      graphviz
      # inputs.nix-hls.packages.x86_64-linux.haskell-language-server-921
      haskell-language-server
      # (hlsHpkgs "ghc8107").haskell-language-server
      haskellPackages.cabal-install
      haskellPackages.fourmolu
      haskellPackages.hasktags
      haskellPackages.hoogle
      haskellPackages.implicit-hie
      haskell.compiler.ghc8107
      # haskell.compiler.ghc921
      haskellPackages.fourmolu
      hddtemp
      hpack
      htop
      hyperfine
      imagemagick
      inkscape
      irony-server
      ispell
      jitsi
      jq
      killall
      lm_sensors
      less
      lorri
      lsb-release
      # mplayer => vlc
      (symlinkJoin {
        name = "mplayer";
        paths = [ vlc mplayer ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          makeWrapper ${vlc}/bin/vlc $out/bin/vplayer --add-flags "-I dummy"
        '';
      })
      # (runCommand "mplayer" { buildInputs = [ makeWrapper ]; }
      #   ''makeWrapper ${vlc}/bin/vlc $out/bin/mplayer --add-flags "-I dummy"'')
      # nix
      inputs.nixF.defaultPackage.x86_64-linux
      maim
      moreutils
      nixfmt
      nix-top
      nix-prefetch-scripts
      networkmanagerapplet
      nodejs
      notify-desktop
      obs-studio
      ormolu
      pasystray
      pciutils
      peek
      pinentry
      pmount
      pulsemixer
      python39Full
      python39Packages.python-lsp-server
      ripgrep
      rnix-lsp
      rxvt-unicode
      slack
      stretchly
      teams
      tmux
      tokei
      tree
      xscreensaver
      xclip
      xdotool
      yarn
      yt-dlp
      zoom-us
    ];
  };

  # Speed up direnv
  services = {
    lorri.enable = true;
    gpg-agent = {
      enable = true;
      # defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    picom = {
      enable = true;
      shadow = false;
      fade = true;
      fadeDelta = 4;
      blur = true;
      inactiveOpacity = "0.90";
      opacityRule = [
        # Opaque at all times
        "100:class_g = 'Firefox'"
        "100:class_g = 'feh'"
        "100:class_g = 'Sxiv'"
        "100:class_g = 'Zathura'"
        "100:class_g = 'Octave'"
        "100:class_g = 'vlc'"
        "100:class_g = 'obs'"
        "100:class_g = 'Wine'"
        "100:class_g = 'Microsoft Teams - Preview'"
        "100:class_g = 'zoom'"
        "100:class_g = 'krita'"
        "100:class_g = 'PureRef'"
        "100:class_g = 'game'"
        # Slightly transparent even when focused
        "95:class_g = 'VSCodium' && focused"
        "95:class_g = 'discord' && focused"
        "95:class_g = 'Spotify' && focused"
        "95:class_g = 'kitty' && focused"
      ];
      blurExclude = [
        "name *= 'rect-overlay'" # teams screenshare overlay
        "class_g = 'peek'"
      ];
      # fixes flickering problems with glx backend
      backend = "xrender";
    };
    unclutter.enable = true;
    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 5000;
      };
      latitude = "62.24";
      longitude = "25.70";
    };
  };
  programs = {
    lsd.enable = true;
    feh.enable = true;
    fzf.enable = true;
    direnv.enable = true;
    # home-manager.enable = true;

    doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
      # emacsPackage = pkgs.emacsGcc;
      # emacsPackagesOverlay = inputs.emacs-overlay.overlay;
    };
    #
    # GIT
    #
    git = {
      enable = true;
      userName = "Providence Salumu";
      userEmail = "Providence.Salumu@smunix.com";
      signing.signByDefault = true;
      signing.key = "7194708EDF5E8EB63EDCF5AD8CB56077D6D39792";
      ignores = [
        "*.nogit*"
        ".envrc"
        ".vscode"
        ".vim"
        "Session.vim"
        "dist-newstyle"
        "result"
      ];
      lfs.enable = true;
      delta.enable = true;
      extraConfig = {
        pull = { rebase = true; };
        fetch = { prune = true; };
        diff = { colorMoved = "zebra"; };
      };
    };
    #
    # FISH
    #
    fish = {
      enable = true;
      interactiveShellInit = ''
        if not set -q TMUX
          exec tmux
        end
      '';
      shellAbbrs = {
        ls = "lsd";
        l = "lsd -al";
        ll = "lsd -l";
        clip = "xclip -sel clip";
        # git
        ga = "git add";
        gc = "git commit -v";
        "gc!" = "git commit -v --amend";
        gl = "git pull";
        gf = "git fetch";
        gco = "git checkout";
        gd = "git diff";
        gsh = "git show";
        gst = "git status";
        gb = "git branch";
        gsta = "git stash";
        gstp = "git stash pop";
        glg = "git log --stat";
        glga = "git log --stat --graph --all";
        glo = "git log --oneline";
        gloa = "git log --oneline --graph --all";
        grh = "git reset HEAD";
      };
      # generally use abbrs for readability,
      # but some long commands are better off as aliases
      shellAliases = {
        lt = "lsd --tree -I node_modules -I build -I target -I __pycache__";
      };
    };
    #
    # STARSHIP
    #
    starship = {
      enable = true;
      settings = {
        format = pkgs.lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$rust"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$battery"
          "$nix_shell"
          "$character"
        ];
        cmd_duration.min_time = 1;
        directory.fish_style_pwd_dir_length = 1;
        git_status = {
          ahead = "⇡$count";
          diverged = "⇕⇡$ahead_count⇣$behind_count";
          behind = "⇣$count";
          modified = "*";
        };
        nix_shell = {
          format = "[$state ]($style)";
          impure_msg = "λ";
          pure_msg = "λλ";
        };
        package.disabled = true;
      };
    };
    #
    # KITTY
    #
    kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono Medium Nerd Font Complete";
        package = pkgs.jetbrains-mono;
      };
      settings = {
        font_size = 11;
        disable_ligatures = "cursor";
        # solarized dark colors
        foreground = "#839496";
        foreground_bold = "#eee8d5";
        cursor = "#839496";
        cursor_foreground = "#002b36";
        background = "#002b36";
        # dark backgrounds
        color0 = "#073642";
        color8 = "#002b36";
        # light backgrounds
        color7 = "#eee8d5";
        color15 = "#fdf6e3";
        # grays
        color10 = "#586e75";
        color11 = "#657b83";
        color12 = "#839496";
        color14 = "#93a1a1";
        # accents
        color1 = "#dc322f";
        color9 = "#cb4b16";
        color2 = "#859900";
        color3 = "#b58900";
        color4 = "#268bd2";
        color5 = "#d33682";
        color13 = "#6c71c4";
        color6 = "#2aa198";
        color16 = "#cb4b16";
        color17 = "#d33682";
        color18 = "#073642";
        color19 = "#586e75";
        color20 = "#839496";
        color21 = "#eee8d5";
      };
    };
  };
  xsession = {
    windowManager = { awesome.enable = true; };
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };
}
