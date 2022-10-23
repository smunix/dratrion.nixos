{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.develop.llvm;
  devCfg = config.modules.develop.xdg;
  codeCfg = config.modules.desktop.editors.vscodium;
  llvm.packages = pkgs."llvmPackages_${cfg.version}";
in {
  options.modules.develop.llvm = {
    enable = mkBoolOpt false;
    version = mkOption {
      description = "LLVM version to compile zig with (min required is 14)";
      default = 14;
      example = 14;
      apply = toString;
      type = types.int;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = [
        llvm.packages.clang
        llvm.packages.libcxx
      ];
    })
    (mkIf devCfg.enable {
      # TODO:
    })
  ];
}
