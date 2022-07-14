{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.gpgpu;
in {
  options.modules.hardware.gpgpu = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    };
  };
}
