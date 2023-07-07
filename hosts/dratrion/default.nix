{ pkgs, config, lib, ... }: {

  imports = [ ./hwCfg.nix ./v4l2.nix ];

  nix.settings.allow-import-from-derivation = true;

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

    themes = {
      active = "catppuccin";
      font = {
        mono.family = "Iosevka Nerd Font Mono";
        mono.size = 8;
        sans.family = "Iosevka Nerd Font";
        sans.size = 8;
        emoji = "Twitter Color Emoji";
      };
      # font = {
      #   mono.family = "Consolas Nerd Font Mono";
      #   mono.size = 8;
      #   sans.family = "Consolas Nerd Font";
      #   sans.size = 8;
      #   emoji = "Twitter Color Emoji";
      # };
     };

    desktop = {
      xmonad.enable = false;
      qtile.enable = true;
      terminal = {
        default = "kitty";
        alacritty.enable = false;
        kitty.enable = true;
        zellij.enable = true;
        nushell.enable = true;
      };
      editors = {
        default = "emacs";
        neovim.enable = false;
        emacs.enable = true;
        emacs.doom.enable = true;
        neovim.agasaya.enable = false;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = false;
        chrome.enable = true;
      };
      philomath.aula = {
        zoom.enable = true;
        obs-studio.enable = true;
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
          sioyek.enable = false;
          zathura.enable = false;
        };
      };
      virtual.wine.enable = false;
    };

    develop = {
      llvm.enable = true;
      cc.enable = true;
      haskell.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.enable = false;
      zig.enable = true;
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
      fish.enable = false;
      nushell.enable = true;
      gnupg.enable = true;
      htop.enable = true;
      utils.enable = true;
      tmux.enable = false;
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
