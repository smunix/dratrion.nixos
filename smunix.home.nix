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
      (_: p: { picom = p.picom.overrideAttrs (_: { src = inputs.jpicom; }); })
    ];
  };
  fonts = { fontconfig.enable = true; };
  home = {
    stateVersion = "22.05";
    file = {
      "axarva.fonts" = {
        source = ./axarva/fonts;
        target = "./.local/share/fonts";
      };
      "axarva.rofi" = {
        source = ./axarva/config/rofi;
        target = "./.config/rofi";
      };
      "axarva.eww" = {
        source = ./axarva/config/eww-1920;
        target = "./.config/eww";
      };
      "axarva.picom" = {
        source = ./axarva/config/picom.conf;
        target = "./.config/picom.conf";
      };
      "axarva.tint2" = {
        source = ./axarva/config/tint2;
        target = "./.config/tint2";
      };
      "axarva.dunst" = {
        source = ./axarva/config/dunst;
        target = "./.config/axarva/dunst";
      };
      "awesome" = {
        source = ./awesome.dratrion;
        # source = ./awesome.moletrooper;
        target = "./.config/awesome";
      };
      "xscreensaver" = { source = ./.xscreensaver; };
      "stalonetrayrc" = {
        source = pkgs.writeText "stalonetrayrc" ''
          decorations none
          transparent false
          dockapp_mode none
          geometry 5x1-540+0
          # max_geometry 5x1-325-20
          max_geometry 0x0
          background "#000000"
          kludges force_icons_size
          grow_gravity NE
          icon_gravity NE
          icon_size 12
          sticky true
          #window_strut none
          window_type dock
          window_layer bottom
          #no_shrink false
          skip_taskbar false
        '';
        target = "./.stalonetrayrc";
      };
      # "tmux" = {
      #   source = ./tmux.dratrion;
      #   target = "./.tmux";
      # };
      "xmobarrc" = {
        source = pkgs.writeText "xmobarrc" ''
          Config {
                 -- font = "xft:Monospace:pixelsize=11",
                 -- used to make the bar appear correctly after Mod-q in older xmonad implementations (0.9.x)
                 -- doesn't seem to do anything anymore (0.10, darcs)
                 -- lowerOnStart = False,
                 -- position = Static { xpos = 0, ypos = 0, width = 2048, height = 20},
                 commands = [
                          -- Addison, TX
                          Run Weather "KADS" ["-t"," <tempC>C","-L","45","-H","74","--normal","green","--high","red","--low","lightblue"] 36000,
                          Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10,
                          Run Memory ["-t","Mem: <usedratio>%"] 10,
                          Run Swap [] 10,
                          Run Date "%a %b %_d %l:%M" "date" 10,
                          Run Com "uname" ["-n", "-r"] "" 36000,
                          Run Network "wlp69s0" [] 10,
                          Run StdinReader
                          ]
                 , sepChar = "%"
                 , alignSep = "}{"
                 , template = "%StdinReader% }{ %wlp69s0% | %cpu% | %memory% * %swap%    <fc=#ee9a00>%date%</fc> | %KADS% | %uname%"
                 }
        '';
      };
    };
    packages = with pkgs; [
      ack
      acpi
      ag
      arc-icon-theme
      bat
      binutils
      bluezFull
      bottom
      ccls
      (writeShellScriptBin "launchExtMSAD" ''
        ${citrix_workspace}/bin/wfica -sound -geometry 1024x928+0+0 ~/Downloads/launchExtMSAD.ica
      '')
      colmena
      conky
      direnv
      dconf
      dmenu
      dos2unix
      dtrx
      du-dust
      entr
      et
      evince
      fd
      feh
      file
      ffmpeg
      file
      fish
      gcc
      ghcid
      gifski
      gimp
      gimpPlugins.gmic
      git
      git-quick-stats
      glab
      gh
      gmic
      google-chrome-dev
      graphviz
      # inputs.nix-hls.packages.x86_64-linux.haskell-language-server-921
      inputs.nix-hls.packages.x86_64-linux.haskell-language-server-8107
      inputs.eww.defaultPackage.x86_64-linux
      # haskell-language-server
      # (hlsHpkgs "ghc8107").haskell-language-server
      haskellPackages.cabal-install
      haskellPackages.fourmolu
      haskellPackages.greenclip
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
      (symlinkJoin {
        name = "office";
        paths = [ libreoffice ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
          makeWrapper ${libreoffice}/bin/libreoffice $out/bin/office
        '';
      })
      maim
      moreutils
      nixfmt
      nix-top
      nix-prefetch-scripts
      networkmanager
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
      rofi
      rofi-menugen
      rofi-file-browser
      rofi-systemd
      rofi-calc
      rofi-power-menu
      rofimoji
      wmctrl
      playerctl
      tint2
      (writeShellScriptBin "inhibitor.sh" ''
        printf "%s" "$SEP1"
        if [ -z "$(pgrep xautolock)" ]
        then
            printf ""
        else
            printf ""
        fi
        printf "%s" " "
      '')
      (writeShellScriptBin "networkclick.sh" ''
        x=$(${networkmanager}/bin/nmcli -a | grep 'Wired connection' | awk 'NR==1{print $1}')
        y=$(${networkmanager}/bin/nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -c 5-)

        if [ -z "$x" ] && [ -z "$y" ]; then
            ${libnotify}/bin/notify-send "Not Connected" -i ${self}/axarva/config/dunst/images/no-connection.png
            exit 1
        elif [ -z "$x" ]; then
            ${libnotify}/bin/notify-send "Connected to $y" -i ${self}/axarva/config/dunst/images/wifi.png
            exit 1
        elif [ -z "$y" ]; then
            ${libnotify}/bin/notify-send "Connected to $x" -i ${self}/axarva/config/dunst/images/ethernet.png
            exit 1
        fi
      '')
      (writeShellScriptBin "battery.sh" ''
        # A dwm_bar function to read the battery level and status
        # Joe Standring <git@joestandring.com>
        # GNU GPLv3

            # Change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1
            CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
            STATUS=$(cat /sys/class/power_supply/BAT0/status)

            printf "%s" "$SEP1"
                if [ "$STATUS" = "Charging" ]; then
                    printf " " #"$CHARGE" "+" #🔌
            	elif [ $CHARGE -le 75 ] && [ $CHARGE -gt 50  ]; then
        	    printf " " #"$CHARGE"
        	elif [ $CHARGE -le 50 ] && [ $CHARGE -gt 25  ]; then
        	    printf " " #"$CHARGE"
        	elif [ $CHARGE -le 25 ] && [ $CHARGE -gt 10  ]; then
        	    printf " " #"$CHARGE"
        	elif [ $CHARGE -le 10 ]; then
        	    printf " "  "!!"
                else
                    printf " " #"$CHARGE" #🔋
                fi
            printf "%s" #"$SEP2"
      '')
      (writeShellScriptBin "networkmanager.sh" ''
        # A dwm_bar function to show the current network connection/SSID, private IP, and public IP using NetworkManager
        # Joe Standring <git@joestandring.com>
        # GNU GPLv3

        # Dependencies: NetworkManager, curl

            CONNAME=$(${networkmanager}/bin/nmcli -a | grep 'Wired connection' | awk 'NR==1{print $1}')
            if [ "$CONNAME" = "" ]; then
                CONNAME=$(${networkmanager}/bin/nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -c 5-)
            fi

            PRIVATE=$(${networkmanager}/bin/nmcli -a | grep 'inet4 192' | awk '{print $2}')
            PUBLIC=$(curl -s https://ipinfo.io/ip)

            printf "%s" "$SEP1"
        	if [ "$CONNAME" != "" ]; then
                    printf " %s" # %s" "$CONNAME" ########"$PRIVATE" "$PUBLIC"🌐
                else
        	    printf " %s"
        	fi
            printf "%s" #"$SEP2"
      '')
    ];
  };

  # Speed up direnv
  services = {
    lorri.enable = true;
    pasystray.enable = true;
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
    dunst.enable = true;
    xidlehook = { enable = false; };
    xscreensaver.enable = true;
    betterlockscreen.enable = false;
    udiskie = { enable = true; };
    pulseeffects.enable = true;
    notify-osd.enable = true;
    caffeine.enable = true;
    gpg-agent = {
      enable = true;
      # defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
    picom = {
      enable = true;
      shadow = true;
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
      extraOptions = (builtins.readFile ./axarva/config/picom.conf);
    };
    unclutter.enable = true;
    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 5000;
      };
      latitude = "45.48";
      longitude = "73.56";
    };
  };

  programs = with pkgs; {
    lsd.enable = true;
    feh.enable = true;
    fzf.enable = true;
    direnv.enable = true;
    home-manager.enable = true;
    # dconf.enable = true;
    eclipse = {
      enable = true;
      package = eclipses.eclipse-cpp;
    };
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
        init = { defaultBranch = "main"; };
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
        # nix
        n = "nix";
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
        font_size = 8;
        # disable_ligatures = "cursor";
        # # solarized dark colors
        # foreground = "#839496";
        # foreground_bold = "#eee8d5";
        # cursor = "#839496";
        # cursor_foreground = "#002b36";
        # background = "#002b36";
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
    windowManager = {
      awesome = { enable = false; };
      xmonad = with pkgs; {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = hpkgs: with hpkgs; [ containers directory taffybar ];
        config = writeText "xmonad.hs" ''
          {-# LANGUAGE OverloadedStrings #-}
          import XMonad
          import XMonad.Config.Desktop
          import XMonad.Hooks.DynamicLog

          -- Prompt
          import XMonad.Prompt
          import XMonad.Prompt.RunOrRaise (runOrRaisePrompt)
          import XMonad.Prompt.AppendFile (appendFilePrompt)

          import System.Directory
          import System.IO (hPutStrLn)
          import System.Exit (exitSuccess)
          import qualified XMonad.StackSet as W

              -- Actions
          import XMonad.Actions.CopyWindow (kill1)
          import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
          import XMonad.Actions.GridSelect
          import XMonad.Actions.MouseResize
          import XMonad.Actions.Promote
          import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
          import XMonad.Actions.WindowGo (runOrRaise)
          import XMonad.Actions.WithAll (sinkAll, killAll)
          import qualified XMonad.Actions.Search as S

              -- Data
          import Data.Char (isSpace, toUpper)
          import Data.Monoid
          import Data.Maybe (fromJust, isJust, maybeToList)
          import Data.Tree
          import qualified Data.Map as M
          import Control.Monad ( join, when )

              -- Hooks
          import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
          import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
          import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, docks, ToggleStruts(..))
          import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
          import XMonad.Hooks.ServerMode
          import XMonad.Hooks.SetWMName
          import XMonad.Hooks.WorkspaceHistory
          import XMonad.Hooks.FadeInactive
          import XMonad.Hooks.UrgencyHook

              -- Layouts
          import XMonad.Layout.Accordion
          import XMonad.Layout.GridVariants (Grid(Grid))
          import XMonad.Layout.SimplestFloat
          import XMonad.Layout.Spiral
          import XMonad.Layout.ResizableTile
          import XMonad.Layout.Tabbed
          import XMonad.Layout.ThreeColumns

          import XMonad.Layout.Gaps
              ( Direction2D(D, L, R, U),
                gaps,
                setGaps,
                GapMessage(DecGap, ToggleGaps, IncGap) )

              -- Layouts modifiers
          import XMonad.Layout.LayoutModifier
          import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
          import XMonad.Layout.Magnifier
          import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
          import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
          import XMonad.Layout.NoBorders
          import XMonad.Layout.Renamed
          import XMonad.Layout.ShowWName
          import XMonad.Layout.Simplest
          import XMonad.Layout.Spacing
          import XMonad.Layout.SubLayouts
          import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
          import XMonad.Layout.WindowNavigation
          import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
          import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

             -- Utilities
          import XMonad.Util.Dmenu
          import XMonad.Util.EZConfig (additionalKeysP, additionalKeys)
          import XMonad.Util.NamedScratchpad
          import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
          import XMonad.Util.SpawnOnce

          import Color
          import Fonts
          import System.Taffybar.Support.PagerHints (pagerHints)

          myFont :: String
          myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

          myModMask :: KeyMask
          myModMask = mod4Mask        -- Sets modkey to super/windows key

          myTerminal :: String
          myTerminal = "${kitty}/bin/kitty"    -- Sets default terminal

          myBrowser :: String
          myBrowser = "google-chrome-unstable"  -- Sets qutebrowser as browser

          myEmacs :: String
          myEmacs = "${emacs}/bin/emacs"  -- Makes emacs keybindings easier to type

          myEditor :: String
          myEditor = "${emacs}/bin/emacs"  -- Sets emacs as editor

          -- Whether focus follows the mouse pointer.
          myFocusFollowsMouse :: Bool
          myFocusFollowsMouse = True

          -- Whether clicking on a window to focus also passes the click to the window
          myClickJustFocuses :: Bool
          myClickJustFocuses = False

          -- Width of the window border in pixels.
          myBorderWidth :: Dimension
          myBorderWidth = 2           -- Sets border width for windows

          myNormColor :: String       -- Border color of normal windows
          myNormColor   = colorBack   -- This variable is imported from Colors.THEME

          myFocusColor :: String      -- Border color of focused windows
          myFocusColor  = color15     -- This variable is imported from Colors.THEME

          windowCount :: X (Maybe String)
          windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

          -- Border colors for unfocused and focused windows, respectively.
          --
          myNormalBorderColor  = "#3b4252"
          myFocusedBorderColor = "#bc96da"

          addNETSupported :: Atom -> X ()
          addNETSupported x   = withDisplay $ \dpy -> do
              r               <- asks theRoot
              a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
              a               <- getAtom "ATOM"
              liftIO $ do
                 sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
                 when (fromIntegral x `notElem` sup) $
                   changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

          addEWMHFullscreen :: X ()
          addEWMHFullscreen   = do
              wms <- getAtom "_NET_WM_STATE"
              wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
              mapM_ addNETSupported [wms, wfs]

          ------------------------------------------------------------------------
          -- Key bindings. Add, modify or remove key bindings here.
          --
          clipboardy :: MonadIO m => m () -- Don't question it
          clipboardy = spawn "rofi -modi \"\63053 :greenclip print\" -show \"\63053 \" -run-command '{cmd}' -theme ~/.config/rofi/launcher/style.rasi"

          centerlaunch = spawn "exec ~/bin/eww open-many blur_full weather profile quote search_full incognito-icon vpn-icon home_dir screenshot power_full reboot_full lock_full logout_full suspend_full"
          sidebarlaunch = spawn "exec ~/bin/eww open-many weather_side time_side smol_calendar player_side sys_side sliders_side"
          ewwclose = spawn "exec ~/bin/eww close-all"
          -- maimcopy = spawn "maim -s | xclip -selection clipboard -t image/png && notify-send \"Screenshot\" \"Copied to Clipboard\" -i flameshot"
          -- maimsave = spawn "maim -s ~/Desktop/$(date +%Y-%m-%d_%H-%M-%S).png && notify-send \"Screenshot\" \"Saved to Desktop\" -i flameshot"
          rofi_launcher = spawn "rofi -no-lazy-grab -show drun -modi run,drun,window -theme $HOME/.config/rofi/launcher/style -drun-icon-theme \"candy-icons\" "

          myStartupHook :: X ()
          myStartupHook = do
            return ()

          myColorizer :: Window -> Bool -> X (String, String)
          myColorizer = colorRangeFromClassName
                            (0x28,0x2c,0x34) -- lowest inactive bg
                            (0x28,0x2c,0x34) -- highest inactive bg
                            (0xc7,0x92,0xea) -- active bg
                            (0xc0,0xa7,0x9a) -- inactive fg
                            (0x28,0x2c,0x34) -- active fg

          -- gridSelect menu layout
          mygridConfig :: p -> GSConfig Window
          mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
              { gs_cellheight   = 40
              , gs_cellwidth    = 200
              , gs_cellpadding  = 6
              , gs_originFractX = 0.5
              , gs_originFractY = 0.5
              , gs_font         = myFont
              }

          spawnSelected' :: [(String, String)] -> X ()
          spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
              where conf = def
                             { gs_cellheight   = 40
                             , gs_cellwidth    = 200
                             , gs_cellpadding  = 6
                             , gs_originFractX = 0.5
                             , gs_originFractY = 0.5
                             , gs_font         = myFont
                             }

          --Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
          mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
          mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

          -- Below is a variation of the above except no borders are applied
          -- if fewer than two windows. So a single window has no gaps.
          mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
          mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

          -- Defining a bunch of layouts, many that I don't use.
          -- limitWindows n sets maximum number of windows displayed for layout.
          -- mySpacing n sets the gap size around the windows.
          tall     = renamed [Replace "tall"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ limitWindows 12
                     $ mySpacing 8
                     $ ResizableTall 1 (3/100) (1/2) []
          magnify  = renamed [Replace "magnify"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ magnifier
                     $ limitWindows 12
                     $ mySpacing 8
                     $ ResizableTall 1 (3/100) (1/2) []
          monocle  = renamed [Replace "monocle"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ limitWindows 20 Full
          floats   = renamed [Replace "floats"]
                     $ smartBorders
                     $ limitWindows 20 simplestFloat
          grid     = renamed [Replace "grid"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ limitWindows 12
                     $ mySpacing 8
                     $ mkToggle (single MIRROR)
                     $ Grid (16/10)
          spirals  = renamed [Replace "spirals"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ mySpacing' 8
                     $ spiral (6/7)
          threeCol = renamed [Replace "threeCol"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ limitWindows 7
                     $ ThreeCol 1 (3/100) (1/2)
          threeRow = renamed [Replace "threeRow"]
                     $ smartBorders
                     $ windowNavigation
                     $ addTabs shrinkText myTabTheme
                     $ subLayout [] (smartBorders Simplest)
                     $ limitWindows 7
                     -- Mirror takes a layout and rotates it by 90 degrees.
                     -- So we are applying Mirror to the ThreeCol layout.
                     $ Mirror
                     $ ThreeCol 1 (3/100) (1/2)
          tabs     = renamed [Replace "tabs"]
                     -- I cannot add spacing to this layout because it will
                     -- add spacing between window and tabs which looks bad.
                     $ tabbed shrinkText myTabTheme
          tallAccordion  = renamed [Replace "tallAccordion"]
                     $ Accordion
          wideAccordion  = renamed [Replace "wideAccordion"]
                     $ Mirror Accordion

          -- setting colors for tabs layout and tabs sublayout.
          myTabTheme = def { activeColor         = color15
                           , inactiveColor       = color08
                           , activeBorderColor   = color15
                           , inactiveBorderColor = colorBack
                           , activeTextColor     = colorBack
                           , inactiveTextColor   = color16
                           }

          -- Theme for showWName which prints current workspace when you change workspaces.
          myShowWNameTheme :: SWNConfig
          myShowWNameTheme = def
              { swn_fade              = 1.0
              , swn_bgcolor           = "#1c1f24"
              , swn_color             = "#ffffff"
              }

          -- The layout hook
          myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
                         $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
                       where
                         myDefaultLayout =     withBorder myBorderWidth tall
                                           ||| magnify
                                           ||| noBorders monocle
                                           ||| floats
                                           ||| noBorders tabs
                                           ||| grid
                                           ||| spirals
                                           ||| threeCol
                                           ||| threeRow
                                           ||| tallAccordion
                                           ||| wideAccordion

          myWorkspaces = zipWith (\i w -> show i <> ":" <> w) [1 ..] ["xterm", "www", "remote", "dev", "chat", "doc", "vid"]
          myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]

          clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
              where i = fromJust $ M.lookup ws myWorkspaceIndices

          myManageHook :: ManageHook
          myManageHook = composeAll . concat $
            [ [ resource =? r --> doIgnore | r <- myIgnores ]
            , [ className =? c --> doShift "1:xterm" | c <- myXterm ]
            , [ className =? c --> doShift "2:www" | c <- myWww ]
            , [ className =? c --> doShift "3:remote" | c <- myRemote ]
            , [ className =? c --> doShift "4:dev" | c <- myDev ]
            , [ className =? c --> doShift "5:chat" | c <- myChat ]
            , [ className =? c --> doShift "6:doc" | c <- myDoc ]
            , [ className =? c --> doShift "7:vid" | c <- myVid ]
            , [ className =? c --> doCenterFloat | c <- myFloats ]
            , [ name =? n --> doCenterFloat | n <- myNames ]
            , [ isFullscreen --> myDoFullFloat ]
            ]
            where
              myIgnores = []
              myXterm = ["kitty"]
              myWww = ["Firefox", "Google-chrome-unstable", "google-chrome-unstable"]
              myRemote = ["Wfica"]
              myDev = ["Eclipse", "java", "Java", "Emacs", "emacs", "Gimp", "gimp", "VirtualBox Manager", "Inkscape", "org.inkscape.Inkscape"]
              myChat = []
              myDoc = ["Evince", "evince", "libreoffice", "libreoffice-startcenter"]
              myVid = ["vlc", "obs", "zoom"]
              myNames = ["Google Chrome"]
              myFloats = ["Firefox", "Gimp", "obs"]

              name = stringProperty "WM_NAME"
              role = stringProperty "WM_WINDOW_ROLE"

              myDoFullFloat :: ManageHook
              myDoFullFloat = doF W.focusDown <+> doFullFloat

          -- Prompt Config {{{
          mXPConfig :: XPConfig
          mXPConfig =
              defaultXPConfig { font                  = barFont
                              , bgColor               = colorDarkGray
                              , fgColor               = colorGreen
                              , bgHLight              = colorGreen
                              , fgHLight              = colorDarkGray
                              , promptBorderWidth     = 0
                              , height                = 14
                              , historyFilter         = deleteConsecutive
                              }

          -- Run or Raise Menu
          largeXPConfig :: XPConfig
          largeXPConfig = mXPConfig
                          { font = xftFont
                          , height = 22
                          }
          -- }}}

          -- START_KEYS
          myKeys conf@(XConfig {XMonad.modMask = modMask}) = conf `additionalKeys`
            [ ((modMask, xK_r), spawn "dmenu_run -i -p \"Run: \"")
            , ((modMask, xK_l), spawn "xscreensaver-command -lock")
            -- terminals
            , ((modMask .|. shiftMask, xK_Return), windows W.swapMaster)
            , ((modMask, xK_Return), spawn $ XMonad.terminal conf)
            -- multimedia keys
            , ((0, 0x1008ff12), spawn "${pulsemixer}/bin/pulsemixer --toggle-mute")
            , ((0, 0x1008ff11), spawn "${pulsemixer}/bin/pulsemixer --change-volume -10")
            , ((0, 0x1008ff13), spawn "${pulsemixer}/bin/pulsemixer --change-volume +10")
            -- sizing windows
            , ((modMask .|. shiftMask, xK_h), sendMessage XMonad.Shrink)
            , ((modMask .|. shiftMask, xK_l), sendMessage XMonad.Expand)
            -- launch rofi and dashboard
            , ((modMask,               xK_o     ), rofi_launcher)
            , ((modMask,               xK_p     ), centerlaunch)
            , ((modMask .|. shiftMask, xK_p     ), ewwclose)

            -- launch eww sidebar
            , ((modMask,               xK_s     ), sidebarlaunch)
            , ((modMask .|. shiftMask, xK_s     ), ewwclose)

            ]
          myKeys_ :: [(String, X ())]
          myKeys_ =
              -- KB_GROUP Xmonad
                  [ ("M-C-r", spawn "xmonad --recompile")       -- Recompiles xmonad
                  , ("M-S-r", spawn "xmonad --restart")         -- Restarts xmonad
                  , ("M-S-q", io exitSuccess)                   -- Quits xmonad

              -- KB_GROUP Get Help
                  , ("M-S-/", spawn "~/.xmonad/xmonad_keys.sh") -- Get list of keybindings
                  , ("M-/", spawn "dtos-help")                  -- DTOS help/tutorial videos

              -- KB_GROUP Run Prompt
                  , ("M-S-<Return>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu

              -- KB_GROUP Other Dmenu Prompts
              -- In Xmonad and many tiling window managers, M-p is the default keybinding to
              -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
                  , ("M-p h", spawn "dm-hub")           -- allows access to all dmscripts
                  , ("M-p a", spawn "dm-sounds")        -- choose an ambient background
                  , ("M-p b", spawn "dm-setbg")         -- set a background
                  , ("M-p c", spawn "dtos-colorscheme") -- choose a colorscheme
                  , ("M-p C", spawn "dm-colpick")       -- pick color from our scheme
                  , ("M-p e", spawn "dm-confedit")      -- edit config files
                  , ("M-p i", spawn "dm-maim")          -- screenshots (images)
                  , ("M-p k", spawn "dm-kill")          -- kill processes
                  , ("M-p m", spawn "dm-man")           -- manpages
                  , ("M-p n", spawn "dm-note")          -- store one-line notes and copy them
                  , ("M-p o", spawn "dm-bookman")       -- qutebrowser bookmarks/history
                  , ("M-p p", spawn "passmenu")         -- passmenu
                  , ("M-p q", spawn "dm-logout")        -- logout menu
                  , ("M-p r", spawn "dm-reddit")        -- reddio (a reddit viewer)
                  , ("M-p s", spawn "dm-websearch")     -- search various search engines
                  , ("M-p t", spawn "dm-translate")     -- translate text (Google Translate)

              -- KB_GROUP Useful programs to have a keybinding for launch
                  , ("M-<Return>", spawn (myTerminal))
                  , ("M-b", spawn (myBrowser))
                  , ("M-M1-h", spawn (myTerminal ++ " -e htop"))

              -- KB_GROUP Kill windows
                  , ("M-S-c", kill1)     -- Kill the currently focused client
                  , ("M-S-a", killAll)   -- Kill all windows on current workspace

              -- KB_GROUP Workspaces
                  , ("M-.", nextScreen)  -- Switch focus to next monitor
                  , ("M-,", prevScreen)  -- Switch focus to prev monitor
                  , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
                  , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

              -- KB_GROUP Floating windows
                  , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
                  , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
                  , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

              -- KB_GROUP Increase/decrease spacing (gaps)
                  , ("C-M1-j", decWindowSpacing 4)         -- Decrease window spacing
                  , ("C-M1-k", incWindowSpacing 4)         -- Increase window spacing
                  , ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
                  , ("C-M1-l", incScreenSpacing 4)         -- Increase screen spacing

              -- KB_GROUP Grid Select (CTR-g followed by a key)
              --    , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
                  , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
                  , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

              -- KB_GROUP Windows navigation
                  , ("M-m", windows W.focusMaster)  -- Move focus to the master window
                  , ("M-j", windows W.focusDown)    -- Move focus to the next window
                  , ("M-k", windows W.focusUp)      -- Move focus to the prev window
                  , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
                  , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
                  , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
                  , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
                  , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
                  , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

              -- KB_GROUP Layouts
                  , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
                  , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

              -- KB_GROUP Increase/decrease windows in the master pane or the stack
                  , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
                  , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
                  , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
                  , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

              -- KB_GROUP Window resizing
                  , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
                  , ("M-l", sendMessage Expand)                   -- Expand horiz window width
                  , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
                  , ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width

              -- KB_GROUP Sublayouts
              -- This is used to push windows to tabbed sublayouts, or pull them out of it.
                  , ("M-C-h", sendMessage $ pullGroup L)
                  , ("M-C-l", sendMessage $ pullGroup R)
                  , ("M-C-k", sendMessage $ pullGroup U)
                  , ("M-C-j", sendMessage $ pullGroup D)
                  , ("M-C-m", withFocused (sendMessage . MergeAll))
                  -- , ("M-C-u", withFocused (sendMessage . UnMerge))
                  , ("M-C-/", withFocused (sendMessage . UnMergeAll))
                  , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
                  , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

              -- KB_GROUP Scratchpads
              -- Toggle show/hide these programs.  They run on a hidden workspace.
              -- When you toggle them to show, it brings them to your current workspace.
              -- Toggle them to hide and it sends them back to hidden workspace (NSP).
              --    , ("M-s t", namedScratchpadAction myScratchPads "terminal")
              --    , ("M-s m", namedScratchpadAction myScratchPads "mocp")
              --    , ("M-s c", namedScratchpadAction myScratchPads "calculator")

              -- KB_GROUP Controls for mocp music player (SUPER-u followed by a key)
                  , ("M-u p", spawn "mocp --play")
                  , ("M-u l", spawn "mocp --next")
                  , ("M-u h", spawn "mocp --previous")
                  , ("M-u <Space>", spawn "mocp --toggle-pause")

              -- KB_GROUP Emacs (SUPER-e followed by a key)
                  , ("M-e e", spawn (myEmacs ++ ("--eval '(dashboard-refresh-buffer)'")))   -- emacs dashboard
                  , ("M-e b", spawn (myEmacs ++ ("--eval '(ibuffer)'")))   -- list buffers
                  , ("M-e d", spawn (myEmacs ++ ("--eval '(dired nil)'"))) -- dired
                  , ("M-e i", spawn (myEmacs ++ ("--eval '(erc)'")))       -- erc irc client
                  , ("M-e n", spawn (myEmacs ++ ("--eval '(elfeed)'")))    -- elfeed rss
                  , ("M-e s", spawn (myEmacs ++ ("--eval '(eshell)'")))    -- eshell
                  , ("M-e t", spawn (myEmacs ++ ("--eval '(mastodon)'")))  -- mastodon.el
                  , ("M-e v", spawn (myEmacs ++ ("--eval '(+vterm/here nil)'"))) -- vterm if on Doom Emacs
                  , ("M-e w", spawn (myEmacs ++ ("--eval '(doom/window-maximize-buffer(eww \"distro.tube\"))'"))) -- eww browser if on Doom Emacs
                  , ("M-e a", spawn (myEmacs ++ ("--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/\")'")))

              -- KB_GROUP Multimedia Keys
                  , ("<XF86AudioPlay>", spawn "mocp --play")
                  , ("<XF86AudioPrev>", spawn "mocp --previous")
                  , ("<XF86AudioNext>", spawn "mocp --next")
                  , ("<XF86AudioMute>", spawn "amixer set Master toggle")
                  , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
                  , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
                  , ("<XF86HomePage>", spawn "qutebrowser https://www.youtube.com/c/DistroTube")
                  , ("<XF86Search>", spawn "dm-websearch")
                  , ("<XF86Mail>", runOrRaise "thunderbird" (resource =? "thunderbird"))
                  , ("<XF86Calculator>", runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
                  , ("<XF86Eject>", spawn "toggleeject")
                  , ("<Print>", spawn "dm-maim")
                  ]
              -- The following lines are needed for named scratchpads.
                    where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                          nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
          -- END_KEYS
          -- myLogHook :: Handle -> X ()
          myLogHook h = dynamicLogWithPP $ defaultPP
              {
                  ppCurrent           =   dzenColor "#ebac54" "#1B1D1E" . pad
                , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
                , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
                , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
                , ppUrgent            =   dzenColor "#ff0000" "#1B1D1E" . pad
                , ppWsSep             =   " "
                , ppSep               =   "  |  "
                , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
                , ppOutput            =   hPutStrLn h
              }
          main = do
            xmproc <- spawnPipe "${xmobar}/bin/xmobar"
            spawn "${feh}/bin/feh --bg-scale ${self}/awesome.dratrion/wallpaper/wallpaper.jpg"
            -- spawn "${stalonetray}/bin/stalonetray"
            spawn "${conky}/bin/conky -c ~/.conky/conky_system -y100 -c ~/conky_and_lua_by_mr_mattz_danuesx/.conkyrc"
            let cfg = desktopConfig {
                terminal = myTerminal
              , modMask  = myModMask
              , borderWidth = myBorderWidth
              , focusFollowsMouse  = myFocusFollowsMouse
              , clickJustFocuses   = myClickJustFocuses
              , manageHook = myManageHook <+> manageDocks <+> manageHook desktopConfig
              , layoutHook = gaps [(L,15), (R,15), (U,20), (D,30)] $ spacingRaw True (Border 5 5 5 5) True (Border 5 5 5 5) True $ smartBorders $ avoidStruts (myLayoutHook)
              -- , logHook = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd
              , logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  , ppTitle = xmobarColor "green" "" . shorten 50
                  }
              , handleEventHook = docksEventHook
              , workspaces = myWorkspaces
              , focusedBorderColor = myFocusedBorderColor
              , normalBorderColor = myNormalBorderColor
              , startupHook        = myStartupHook >> addEWMHFullscreen
              }
            xmonad $ docks $ ewmh $ pagerHints $ myKeys $ cfg
        '';

        libFiles = {
          "Tools.hs" = writeText "Tool.hs" ''
            module Tools where
            screenshot = "import"
          '';
          "Bar.hs" = ./xmonad/Bar.hs;
          "Config.hs" = ./xmonad/Config.hs;
          "Color.hs" = ./xmonad/Color.hs;
          "Fonts.hs" = ./xmonad/Fonts.hs;
        };
      };
    };
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
  };
}
