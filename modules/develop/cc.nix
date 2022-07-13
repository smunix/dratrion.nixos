{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.develop.cc;
  devCfg = config.modules.develop.xdg;
  codeCfg = config.modules.desktop.editors.vscodium;
in {
  options.modules.develop.cc = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        bear
        ccls
        clang
        cmake
        gdb
        llvmPackages.libcxx
      ];

      hm.programs.eclipse = {
        enable = true;
        package = pkgs.eclipses.eclipse-cpp;
      };
    })

    (mkIf codeCfg.enable {
      hm.programs.vscode.extensions = with pkgs.vscode-extensions; [
        ms-vscode.cpptools
      ];
    })

    (mkIf devCfg.enable {
      # TODO:
    })
  ];
}
