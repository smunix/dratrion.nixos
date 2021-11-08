# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, modulesPath, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
      ./v4l2.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      zeroconf.discovery.enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
      	};
      };
    };
  };

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;
  nixpkgs.config.pulseaudio = true;

  v4l2 = true;  

   # services.postgresql = {
   # enable = true;
   # package = pkgs.postgresql_10;
   # enableTCPIP = true;
   # authentication = pkgs.lib.mkOverride 10 ''
   #   local all all trust
   #   host  all all 127.0.0.1/32 trust
   #   host all all ::1/128 trust
   # '';
   # initialScript = pkgs.writeText "backend-initScript" ''
   #   CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' CREATEDB;
   #   CREATE DATABASE postgres;
   #   GRANT ALL PRIVILEGES ON DATABASE postgres TO postgres;
   # '';
   # };
  
  services.blueman.enable = true;
  services.openssh.forwardX11 = true;
  services.plex = {
    enable = true;
    user = "smunix";
    group = "users";
    dataDir = "/home/smunix/Videos";
    # openFirewall = true;
  };

  nix.trustedUsers = [ "root" "smunix" ];

  networking.hostName = "dratrion"; # Define your hostname.
  networking.nameservers = [ "207.164.234.193" "207.164.234.129"];
  # networking.hosts = {
  #   "192.168.80.81" = [ "aristote" ];
  #   "192.168.80.85" = [ "q45" ];
  #   "192.168.80.80" = [ "dratrion" ];
  #   "192.168.80.42" = [ "printer" ];
  # };

  networking.extraHosts = ''
    155.138.157.218 kagiso
    49.12.70.26 rutwe
  '';

  # networking.wlanInterfaces = {
  #  wlan-station0 = { device = "wlp6s0"; };
  #  wlan-ap0 = { device = "wlp6s0"; mac = "02:e4:e3:7e:20"; };
  #  # wlan-ap1 = { device = "wlp6s0"; mac = "02:e4:e3:7e:22"; };
  #  # wlan2 = { device = "wlp6s0"; mac = "02:e4:e3:7e:24"; };
  #  # wlan3 = { device = "wlp6s0"; mac = "02:e4:e3:7e:26"; };
  #  # wlan4 = { device = "wlp6s0"; mac = "02:e4:e3:7e:28"; };
  # };
  
  # networking.networkmanager.unmanaged = [ "interface-name:wlp*" ] ++ lib.optional config.services.hostapd.enable "interface-name:${config.services.hostapd.interface}";
  # networking.networkmanager.unmanaged = lib.optional config.services.hostapd.enable "interface-name:${config.services.hostapd.interface}";
  
  # services.hostapd = {
  #  enable        = true;
  #  interface     = "wlan-ap0";
  #  hwMode        = "g";
  #  ssid          = "smunix24";
  #  wpaPassphrase = "75F33ekt";
  #  extraConfig = ''
  #    ieee80211n=1
  #    ieee80211ac=1
  #    wmm_enabled=1
  #  '';
  # };
  
  # networking.interfaces.wlan-ap0.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.80.1"; prefixLength = 24; }] ;
  # networking.interfaces.wlan-ap1.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.81.1"; prefixLength = 24; }] ;
  # networking.interfaces.wlan1.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.81.1"; prefixLength = 24; }] ;
  # networking.interfaces.wlan2.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.82.1"; prefixLength = 24; }] ;
  # networking.interfaces.wlan3.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.83.1"; prefixLength = 24; }] ;
  # networking.interfaces.wlan4.ipv4.addresses = lib.optionals config.services.hostapd.enable [{ address = "192.168.84.1"; prefixLength = 24; }] ;
  
  services.dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
    enable = false;
    extraConfig = ''
      interface=wlan-ap0
      bind-interfaces
      log-queries
      log-dhcp
      dhcp-range=wlan-ap0,192.168.80.10,192.168.80.254,24h
      # options
      # dhcp-option=tag:u,option:dns-server,207.164.234.129
      dhcp-option=option:dns-server,192.168.80.1
      host-record=facebook.com,192.168.80.1
      host-record=skype.com,192.168.80.1
      host-record=edge.skype.com,192.168.80.1
      host-record=static.asm.skype.com,192.168.80.1
      host-record=config.edge.skype.com,192.168.80.1
      host-record=consumer.entitlement.skype.com,192.168.80.1
      host-record=options.skype.com,192.168.80.1
      host-record=api.aps.skype.com,192.168.80.1
      host-record=youtube.com,192.168.80.1
      host-record=roblox.com,192.168.80.1
      # gateway server
      dhcp-option=3,192.168.80.1
      # iphone
      dhcp-host=6c:72:e7:b0:4d:c7,iphone,192.168.80.100,set:r
      # pixel3
      dhcp-host=c2:ac:f3:4f:99:1b,pixel3a,192.168.80.101,set:r
      # pixel3xl
      dhcp-host=aa:ed:35:32:a2:97,pixel3xl,192.168.80.102,set:u
      # roku
      dhcp-host=c8:3a:6b:15:80:d4,roku,192.168.80.103,set:r
      # macbook
      dhcp-host=ac:bc:32:a3:d5:b7,macbook,192.168.80.104,set:r
      # aristote
      dhcp-host=5c:51:4f:40:ed:a9,vaio,192.168.80.105,set:r
      # q45
      dhcp-host=00:1b:77:d0:c8:7e,q45,192.168.80.106,set:r
      # android tab
      dhcp-host=ac:22:0b:48:4b:e6,tab,192.168.80.107,set:r
    '';
  };

  # services.dhcpd = {
  #   enable = true;
  #   interfaces = [ "wlp2s0" "enp4s6f0" "enp4s6f1" ]; 
  #   extraConfig = ''
  #     ddns-update-style none;
  #     #option subnet-mask         255.255.255.0;
  #     one-lease-per-client true;

  #     subnet 192.168.1.0 netmask 255.255.255.0 {
  #       range 192.168.1.10 192.168.1.254;
  #       authoritative;

  #       # Allows clients to request up to a week (although they won't)
  #       max-lease-time              604800;
  #       # By default a lease will expire in 24 hours.
  #       default-lease-time          86400;

  #       option subnet-mask          255.255.255.0;
  #       option broadcast-address    192.168.1.255;
  #       option routers              192.168.1.1;
  #       option domain-name-servers  206.248.154.22, 206.248.154.170;
  #     }
  #     subnet 192.168.2.0 netmask 255.255.255.0 {
  #       range 192.168.2.10 192.168.2.254;
  #       authoritative;

  #       # Allows clients to request up to a week (although they won't)
  #       max-lease-time              604800;
  #       # By default a lease will expire in 24 hours.
  #       default-lease-time          86400;

  #       option subnet-mask          255.255.255.0;
  #       option broadcast-address    192.168.2.255;
  #       option routers              192.168.2.1;
  #       option domain-name-servers  206.248.154.22, 206.248.154.170;
  #     }
  #     subnet 192.168.3.0 netmask 255.255.255.0 {
  #       range 192.168.3.10 192.168.3.254;
  #       authoritative;

  #       # Allows clients to request up to a week (although they won't)
  #       max-lease-time              604800;
  #       # By default a lease will expire in 24 hours.
  #       default-lease-time          86400;

  #       option subnet-mask          255.255.255.0;
  #       option broadcast-address    192.168.3.255;
  #       option routers              192.168.3.1;
  #       option domain-name-servers  206.248.154.22, 206.248.154.170;
  #     }
  #   '';
  # };
  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.wireless.networks = {
  #   smunix24 = {
  #     psk="75F33ekt";
  #     # psk = "9f3ae458763308e9e046be7f3f4a5649847ee085166cdf7a20066fc0bab4303f";
  #   };
  # };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#nixos
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
  # ];

  environment.systemPackages = with pkgs; [
    binutils
    # emacsGit
    emacs
    fish
    # google-chrome-dev
    git
    networkmanagerapplet
    vim
    wget
  ];
  
  nixpkgs.config.allowUnfree = true;
  
  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    package = pkgs.nixUnstable;
    sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
    extraOptions = ''
     ${lib.optionalString (config.nix.package == pkgs.nixFlakes || config.nix.package == pkgs.nixUnstable) "experimental-features = nix-command flakes"}
     min-free = ${toString (1 * 1024 * 1024 * 1024)}
     max-free = ${toString (5 * 1024 * 1024 * 1024)}
   '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.fish.enable = true;
  programs.dconf.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.weechat.enable = true;
  programs.screen.screenrc = ''
    multiuser on
    acladd normal_user
  '';
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 22 53 139 443 445 515 631 8080 ]  ++ (lib.optionals config.services.hostapd.enable [80 9999]);
  # networking.firewall.allowedTCPPortRanges = [ { from = 9100; to = 9102; } ];
  # networking.firewall.allowedUDPPorts = [ 137 161 631 5353 ] ++ (lib.optionals config.services.hostapd.enable [53 67]);
  # networking.firewall.extraCommands = ''
  #   ip46tables -A FORWARD -i wlan-ap0 -p tcp -m string --string "facebook.com" --algo kmp -j nixos-fw-log-refuse
  #   ip46tables -A FORWARD -i wlan-ap0 -p tcp -m string --string "youtube.com" --algo kmp -j nixos-fw-log-refuse
  #   ip46tables -A FORWARD -i wlan-ap0 -p tcp -m string --string "roblox.com" --algo kmp -j nixos-fw-log-refuse
  #   ip46tables -A FORWARD -i wlan-ap0 -p tcp -m string --string "skype.com" --algo kmp -j nixos-fw-log-refuse
  # '';

  # NAT
  # networking.nat = {
  #   enable = true;
  #   internalInterfaces = [ "wlan-ap0" ];
  #   externalInterface = "wlan-station0";
  # };
  
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  
  # Enable nftables instead
  networking.nftables = {
    enable = true;
    ruleset = ''
      # FILTER
      table inet filter {
        chain input {
          type filter hook input priority 0;
          policy accept;

	  ct state invalid counter drop comment "early drop of invalid packets"
	  ct state {established, related} counter accept comment "accept all connections related to connections made by us"
	  
	  iif lo accept comment "accept loopback"
	  iif != lo ip daddr 127.0.0.1/8 counter drop comment "drop connections to loopback not coming from loopback"
	  iif != lo ip6 daddr ::1/128 counter drop comment "drop connections to loopback not coming from loopback"

	  ip protocol icmp counter accept comment "accept all ICMP types"
	  ip6 nexthdr icmpv6 counter accept comment "accept all ICMP types"
	  
	  tcp dport { 22, 53, 80, 139, 443, 445, 515, 631, 8080, 9999 } accept
	  tcp dport 9100-9102 accept
	  
	  udp dport { 53, 67, 137, 161, 631, 5353 } accept
	  
	  counter
        }

        chain output {
          type filter hook output priority 0;
          policy accept;
	  counter
        }
	chain fw-wikipedia {
	  ip daddr { 208.80.154.224 } accept
	  ip saddr { 208.80.154.224 } accept
	}
	chain fw-google {
	  ip daddr { 172.217.13.97, 172.217.13.100, 172.217.13.106, 172.217.13.132, 172.217.13.168, 172.217.13.202, 172.217.13.206 } accept
	  ip saddr { 172.217.13.97, 172.217.13.100, 172.217.13.106, 172.217.13.132, 172.217.13.168, 172.217.13.202, 172.217.13.206 } accept
	  
	  ip daddr { 172.217.13.97 - 172.217.13.202 } accept
	  ip saddr { 172.217.13.97 - 172.217.13.202 } accept

	  ip daddr { 172.253.63.100 - 172.253.63.139 } accept
	  ip saddr { 172.253.63.100 - 172.253.63.139 } accept
	}
	chain fw-roblox {
	  ip daddr { 104.69.48.222, 128.116.112.44 } log prefix "drop/fw-roblox " drop
	  ip saddr { 104.69.48.222, 128.116.112.44 } log prefix "drop/fw-roblox " drop
	}
	chain fw-skype {
	  ip daddr { 52.113.194.133, 52.158.121.3, 23.3.115.39, 13.68.20.25, 209.15.13.134, 52.114.128.37, 40.121.80.200, 104.40.50.126, 23.102.255.237, 40.115.34.155 } log prefix "drop/fw-skype " drop
	  ip saddr { 52.113.194.133, 52.158.121.3, 23.3.115.39, 13.68.20.25, 209.15.13.134, 52.114.128.37, 40.121.80.200, 104.40.50.126, 23.102.255.237, 40.115.34.155 } log prefix "drop/fw-skype " drop
	}
	chain fw-facebook {
	  ip daddr { 31.13.71.36 } log prefix "drop/fw-facebook " drop
	  ip saddr { 31.13.71.36 } log prefix "drop/fw-facebook " drop
	}
	chain fw-youtube {
	  ip daddr { 184.144.0.0/13 } log prefix "drop/fw-youtube " drop
	  udp sport { 443 } log prefix "drop/fw-youtube/sport/443 " drop
	  udp dport { 443 } log prefix "drop/fw-youtube/dport/443 " drop
	  jump fw-ssdp
	}
	chain fw-ssdp {
	  udp dport { 1900 } log prefix "drop/fw-ssdp/dport/1900 " drop
	}
	chain fw-roku-ports {
	  tcp dport { 8060, 9080 } log prefix "drop/fw-roku-ports/dport/sets " drop
	  tcp sport { 8060, 9080 } log prefix "drop/fw-roku-ports/sport/sets " drop
	}
	chain fw-192.168.80.100 {
	  counter
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/apple/iphone (fw)" accept
	}
	chain fw-192.168.80.101 {
	  counter
	  accept
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/android/pixel3a (fw)" accept
	}
	chain fw-192.168.80.102 {
	  counter
	  accept
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/android/pixel3xl (fw)" accept
	}
	chain fw-192.168.80.103 {
	  counter
	  accept
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/android/roku (fw)" accept
	}
	chain fw-192.168.80.104 {
	  counter
	  accept
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/apple/macbook (fw)" accept
	}
	chain fw-192.168.80.105 {
	  counter
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/sony/vaio (fw)" accept
	}
	chain fw-192.168.80.106 {
	  counter
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/samsung/q45 (fw)" accept
	}
	chain fw-192.168.80.107 {
	  counter
	  jump fw-roblox
	  jump fw-skype
	  jump fw-facebook
	  jump fw-youtube
	  log prefix "accept/android/tab (fw)" accept
	}
	chain fw-unknown {
	  counter
	  log prefix "drop/<unknown>/<unknown> (fw)" drop
	}
        chain forward {
          type filter hook forward priority 0;
          policy drop;
	  
	  # Allow incoming on wlan-station0 for related & established connections
	  iifname "wlan-station0" ct state related, established accept

	  jump fw-roku-ports
	  jump fw-google
	  jump fw-wikipedia

	  ip saddr { 192.168.80.0/24 } ip daddr { 192.168.80.0/24 } log prefix "drop/192.168.80.xxx/192.168.80.xxx " drop

	  ip saddr 192.168.80.100 goto fw-192.168.80.100
	  ip saddr 192.168.80.101 goto fw-192.168.80.101
	  ip saddr 192.168.80.102 goto fw-192.168.80.102
	  ip saddr 192.168.80.103 goto fw-192.168.80.103
	  ip saddr 192.168.80.104 goto fw-192.168.80.104
	  ip saddr 192.168.80.105 goto fw-192.168.80.105
	  ip saddr 192.168.80.106 goto fw-192.168.80.106
	  ip saddr 192.168.80.107 goto fw-192.168.80.107

	  goto fw-unknown

	  ip saddr 192.168.80.0/24 ip daddr { 128.116.112.44 } log prefix "drop/roblox.com (out) " drop
	  ip saddr 192.168.80.0/24 ip daddr { 52.113.194.133, 52.158.121.3, 23.3.115.39, 13.68.20.25, 209.15.13.134, 52.114.128.37, 40.121.80.200, 104.40.50.126, 23.102.255.237, 40.115.34.155 } log prefix "drop/skype.com (out) " drop
	  # # ip saddr 192.168.80.0/24 ip daddr { 104.244.42.3, 182.150.64.206, 182.150.65.206, 184.150.64.206, 184.150.65.206, 184.150.65.0/24, 184.150.64.0/24, 182.150.65.0/24, 182.150.64.0/24 } log prefix "drop/forward/youtube.com (out) " drop
	  # # ip daddr 192.168.80.0/24 ip saddr { 104.244.42.3, 182.150.64.206, 182.150.65.206, 184.150.64.206, 184.150.65.206, 184.150.65.0/24, 184.150.64.0/24, 182.150.65.0/24, 182.150.64.0/24 } log prefix "drop/forward/youtube.com (in) " drop
	  # # https://www.lifewire.com/ip-address-of-youtube-818157
	  # ip daddr 192.168.80.0/24 ip saddr { 104.244.42.3, 172.217.13.174, 172.217.13.194, 199.223.232.0/24, 207.223.160.0/19, 208.65.152.0/23, 208.117.224.0/22, 209.85.128.0/17, 216.58.192.0/18, 216.239.32.0/19 } log prefix "drop/forward/youtube.com (in) (ranges) " drop
	  # # https://www.lifewire.com/ip-address-of-youtube-818157
	  # ip saddr 192.168.80.0/24 ip daddr { 104.244.42.3, 172.217.13.174, 172.217.13.194, 199.223.232.0/24, 207.223.160.0/19, 208.65.152.0/23, 208.117.224.0/22, 209.85.128.0/17, 216.58.192.0/18, 216.239.32.0/19 } log prefix "drop/forward/youtube.com (out) (ranges) " drop
	  # https://stackoverflow.com/questions/9342782/is-there-a-way-to-get-all-ip-addresses-of-youtube-to-block-it-with-windows-firew
	  ip saddr 192.168.80.0/24 ip daddr { 64.18.0.0/20, 64.233.160.0/19, 66.102.0.0/20, 66.249.80.0/20, 72.14.192.0/18, 74.125.0.0/16, 173.194.0.0/16, 207.126.144.0/20, 209.85.128.0/17, 216.58.208.0/20, 216.239.32.0/19 } log prefix "drop/forward/youtube.com (out) (ranges) " drop
	  # ip saddr 192.168.80.0/24 udp dport { 443 } log prefix "drop/forward/youtube.com (GQUIC) " drop
	  ip saddr 192.168.80.0/24 ip daddr { 31.13.71.36 } log prefix "drop/forward/facebook.com " drop
        }
      }
      # NAT
      table inet nat {
        chain prerouting {
          type nat hook prerouting priority 0;
	  policy accept;

	  counter comment "count prerouting packets"
        }
      
        chain postrouting {
          type nat hook postrouting priority 0;
      	  policy accept;

	  ip saddr 192.168.80.0/24 oifname wlan-station0 masquerade
        }
      }
    '';
  };
  services.haveged.enable = config.services.hostapd.enable;
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.samsungUnifiedLinuxDriver ];

  services.printing.browsing = true;
  services.printing.listenAddresses = [ "*:631" ];
  services.printing.defaultShared = true;
  
  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    windowManager = {
      awesome = {
        enable = true;
	luaModules = [ pkgs.luaPackages.luaposix ];
      };
    };
  };
  services.xserver.autorun = true;

  services.udev.packages = with pkgs; [ android-udev-rules ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.pmount}/bin/pmount --sync --umask 000 %k"
    ACTION=="remove", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.pmount}/bin/pumount -l %k"
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };
  users.users.smunix = {
    isNormalUser = true;
    description = "Providence Salumu";
    createHome = true;
    hashedPassword = "$6$zDM5NpfBa76s$qnMCog144XdTotEl9fxOthwZ/LqU5c8oa/I468HbbceZ1wcWt3/oowHWa61Wq.1aaLOSj/RkLylAwBWX/yGJQ1";
    extraGroups = [ "wheel" "video" "audio" "sound" "bluetooth" "pulse" "disk" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  users.extraUsers.smunix = {
    shell = pkgs.fish;
  };
  # 111611k@yl@
  users.users.kayla = {
    isNormalUser = true;
    description = "Kayla Salumu-A";
    createHome = true;
    hashedPassword = "$6$YQGik.WIk48hfK$PudmFNvLehdzrfwY1n0c3tXrzZiFhiFo8Dpbare1Sfs.IRZAFPqW16lY9gjkZoZ1zX0hUSfWPxVxLjaVpAxNl/";
    extraGroups = [ "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  users.extraUsers.kayla = {
    shell = pkgs.fish;
  };
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  # nelly120804
  users.users.narakaza = {
    isNormalUser = true;
    description = "Nelly Arakaza";
    hashedPassword = "$6$BklNJjKhiRWuvT7m$.a2tNsxURGwnbdwpxp5upk1nEXTMJ9xIWsWk5sx.CQKah/pBvdGk71lFzCr5dyVnfba80tPlj.8x3NIWgXgje/";
    createHome = true;
    extraGroups = [ "audio" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  users.extraUsers.narakaza = {
    shell = pkgs.fish;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  # system.stateVersion = "20.09"; # Did you read the comment?
  
  system = {
    stateVersion = "21.05"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      channel = "https://channels.nixos.org/nixos-unstable-small";
      dates = "02:00";
    };
  };


}

