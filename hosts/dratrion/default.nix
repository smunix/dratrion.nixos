{ pkgs, config, lib, ... }: {

  imports = [ ./hwCfg.nix ./v4l2.nix ];

  modules = {
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      razer.enable = true;
      input.enable = true;
      gpgpu.enable = true;
      v4l2.enable = true;
  };

    networking = {
      enable = true;
      networkManager.enable = true;
      wireGuard = {
        enable = true;
        # akkadianVPN.enable = true;
      };
    };

    themes.active = "catppuccin";

    desktop = {
      xmonad.enable = false;
      qtile.enable = true;
      terminal = {
        default = "kitty";
        alacritty.enable = true;
        kitty.enable = true;
      };
      editors = {
        default = "emacs";
        # nvim.enable = false;
        emacs.enable = true;
        emacs.doom.enable = true;
        neovim.agasaya.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = false;
        chrome.enable = true;
      };
      philomath.aula = {
        zoom.enable = true;
      };
      media = {
        downloader.transmission.enable = false;
        editor = {
          raster.enable = true;
          vector.enable = true;
        };
        social = {
          common.enable = true;
        };
        player = {
          video.enable = true;
          music.enable = true;
        };
        document = {
          sioyek.enable = true;
          zathura.enable = true;
        };
      };
      virtual.wine.enable = false;
    };

    develop = {
      haskell.enable = true;
      python.enable = true;
      rust.enable = false;
      cc.enable = true;
      nix.enable = true;
    };

    containers.transmission = {
      enable = false; # TODO: Once fixed -> enable = true;
      username = "alonzo";
      password = builtins.readFile config.age.secrets.torBylon.path;
    };

    services = {
      ssh.enable = true;
      kdeconnect.enable = true;
    };

    shell = {
      git.enable = true;
      fish.enable = true;
      gnupg.enable = true;
      htop.enable = true;
    };
  };

  services = {
    upower.enable = true;
    printing.enable = true;
    avahi.enable = false;
    gvfs.enable = true;

    xserver = {
      videoDrivers = ["nvidia"];
      deviceSection = ''
        Option "TearFree" "true"
      '';
      libinput.touchpad = {
        accelSpeed = "0.5";
        accelProfile = "adaptive";
      };
    };
  };

##
  # modules.desktop = {
  #   appliances = {
  #     termEmu = {
  #       default = "kitty";
  #       alacritty.enable = true;
  #       kitty.enable = true;
  #     };
  #     editors = {
  #       default = "emacs";
  #       nvim.enable = false;
  #       emacs.enable = true;
  #     };
  #     browsers = {
  #       default = "chrome";
  #       firefox.enable = true;
  #       unGoogled.enable = false;
  #       chrome.enable = true;
  #     };
  #     philomath.aula = {
  #       anki.enable = true;
  #       zoom.enable = true;
  #     };
  #     media = {
  #       mpv.enable = true;
  #       spotify.enable = false;
  #       graphics.enable = true;
  #       docViewer.enable = true;
  #       transmission.enable = false;
  #       chat = {
  #         enable = true;
  #         mobile.enable = true;
  #       };
  #       recording.enable = true;
  #     };
  #     gaming = { steam.enable = false; };
  #   };
  # };

  # modules.develop = {
  #   cc.enable = true;
  #   haskell.enable = true;
  #   haskell.ghc = "ghc_9_2_2";
  #   node.enable = true;
  #   python.enable = true;
  #   rust.enable = true;
  # };

  # modules.containers.transmission = {
  #   enable = false; # TODO: Once fixed -> enable = true;
  #   username = "alonzo";
  #   password = builtins.readFile config.age.secrets.torBylon.path;
  # };

  # modules.services = {
  #   ssh.enable = true;
  #   laptop.enable = true;
  #   kdeconnect.enable = true;
  # };

  # modules.shell = {
  #   git.enable = true;
  #   fish.enable = true;
  #   gnupg.enable = true;
  #   urxvt.enable = true;
  #   nix-index.enable = true;
  # };

  boot.kernel.sysctl."abi.vsyscall32" = 0; # League of Legends..
  boot.kernelParams = [ "acpi_backlight=native" ];

  hardware.opengl.extraPackages =
    [ pkgs.amdvlk pkgs.driversi686Linux.amdvlk pkgs.rocm-opencl-icd ];

  systemd.services.systemd-udev-settle.enable = false;

}
