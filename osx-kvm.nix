{ lib, config, pkgs, ... }:

with lib;

{
  options.osx-kvm = mkEnableOption "https://nixos.wiki/wiki/OSX-KVM";
  config = mkIf config.osx-kvm {
    # https://nixos.wiki/wiki/OSX-KVM
    boot.extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
    virtualisation.libvirtd.enable = true;
    users = { extraUsers = { smunix = { extraGroups = [ "libvirtd" ]; }; }; };
    fileSystems."/run/media/osx-kvm" = {
      device = "/dev/disk/by-label/macosx";
      options = [ "rw" "noatime" "users" ];
      fsType = "btrfs";
    };
  };
}
