# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, modulesPath, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./v4l2.nix
    ./osx-kvm.nix
  ];

  v4l2 = true;
  osx-kvm = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = /dev/sdc;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "dratrion"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "America/New_York";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp69s0.useDHCP = true;
  networking.hosts = { "49.12.70.26" = [ "rutwe" ]; };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services.blueman.enable = true;
  services.urxvtd = { enable = true; };
  services.plex = {
    enable = true;
    user = "smunix";
    group = "users";
    dataDir = "/home/smunix/Videos";
    openFirewall = true;
  };

  services.udev.packages = with pkgs; [ android-udev-rules ];
  # Enable Picom composite WM
  services.picom = {
    enable = true;
    shadow = true;
    opacityRules = [ "100:class_g = 'Firefox' && argb" ];
  };
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    videoDrivers = [ "nvidia" ];
    desktopManager.plasma5.enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "none+awesome";
      sessionCommands = ''
        xrdb "${
          pkgs.writeText "xrdb.conf" ''
            xterm*background:             black
            xterm*foreground:             white
            xterm*vt100.locale:           true
            xterm*vt100.metaSendsEscape:  true

            URxvt.iso14755:               false
            URxvt.iso14755_52:            false

            URxvt.perl-ext-common:        default,matcher,resize-font,url-select,keyboard-select,selection-to-clipboard,fullscreen
            URxvt.transparent:            true
            URxvt.shading:                30

            URxvt.background:             black
            URxvt.foreground:             white

            URxvt.scrollBar:              false
            URxvt.scrollTtyKeypress:      true
            URxvt.scrollTtyOutput:        false
            URxvt.scrollWithBuffer:       false
            URxvt.scrollstyle:            plain
            URxvt.secondaryScroll:        true

            URxvt.colorUL:                #AED210
            URxvt.resize-font.step:       2
            URxvt.matcher.button:         1
            URxvt.url-select.underline:   true

            URxvt.copyCommand:            ${pkgs.xclip}/bin/xclip -i -selection clipboard
            URxvt.pasteCommand:           ${pkgs.xclip}/bin/xclip -o -selection clipboard

            URxvt.keysym.M-c:             perl:clipboard:copy
            URxvt.keysym.M-v:             perl:clipboard:paste

            URxvt.keysym.Shift-Control-V: eval:paste_clipboard
            URxvt.keysym.Shift-Control-C: eval:selection_to_clipboard

            URxvt.keysym.M-Escape:        perl:keyboard-select:activate
            URxvt.keysym.M-s:             perl:keyboard-select:search

            URxvt.keysym.M-u:             perl:url-select:select_next

            URxvt.keysym.C-minus:         resize-font:smaller
            URxvt.keysym.C-plus:          resize-font:bigger
            URxvt.keysym.C-equal:         resize-font:reset
            URxvt.keysym.C-question:      resize-font:show
            URxvt.keysym.C-Down:          resize-font:smaller
            URxvt.keysym.C-Up:            resize-font:bigger

            Xft.antialias:                1
            Xft.autohint:                 0
            Xft.hinting:                  1
            Xft.hintstyle:                hintslight
            Xft.lcdfilter:                lcddefault
            Xft.rgba:                     rgb
          ''
        }"
      '';
    };
    windowManager = {
      awesome = {
        enable = true;
        luaModules = [ pkgs.luaPackages.luaposix ];
      };
    };
  };
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  # 
  users = {
    users = {
      smunix = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "networkmanager" ];
      };
    };
    extraUsers = { smunix = { shell = pkgs.fish; }; };
    extraGroups.vboxusers.members = [ "smunix" ];
  };

  virtualisation = { virtualbox.host.enable = true; };

  systemd.user.services."udiskie" = {
    enable = true;
    description = "udiskie to automount removable media";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      gnome3.defaultIconTheme
      gnome3.gnome_themes_standard
      udiskie
    ];
    environment.XDG_DATA_DIRS =
      "${pkgs.gnome3.defaultIconTheme}/share:${pkgs.gnome3.gnome_themes_standard}/share";
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie -a -t -n -F ";
  };

  nix = {
    autoOptimiseStore = true;
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (1 * 1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';
    trustedUsers = [ "smunix" ];
    binaryCachePublicKeys = [ ];
    binaryCaches = [ "https://cache.nixos.org/" ];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 15d";
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    binutils
    git
    fish
    networkmanagerapplet
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
  programs.fish.enable = true;
  programs.nm-applet.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Speed up direnv
  services.lorri.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "22.05"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      channel = "https://channels.nixos.org/nixos-unstable-small";
      dates = "02:00";
    };
  };
}

