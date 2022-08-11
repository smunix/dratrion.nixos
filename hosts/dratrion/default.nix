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
          evince.enable = true;
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

  boot.kernel.sysctl."abi.vsyscall32" = 0; # League of Legends..
  boot.kernelParams = [ "acpi_backlight=native" ];

  hardware.opengl.extraPackages =
    [ pkgs.amdvlk pkgs.driversi686Linux.amdvlk pkgs.rocm-opencl-icd ];

  systemd.services.systemd-udev-settle.enable = false;

}
