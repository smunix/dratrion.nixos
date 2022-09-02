{
  config,
  options,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.develop.zig;
  devCfg = config.modules.develop.xdg;
  codeCfg = config.modules.desktop.editors.vscodium;
  llvmPkgs = pkgs."llvmPackages_${cfg.llvm}";
  inherit (llvmPkgs) stdenv;
  zyg = with pkgs;
    stdenv.mkDerivation rec {
      name = "zig";
      src = inputs.zig;
      nativeBuildInputs = [ cmake ninja llvmPkgs.llvm.dev ];
      buildInputs = [ libxml2 zlib ] ++ (with llvmPkgs; [
        libclang
        lld
        llvm
      ]);
      preBuild = ''
        export HOME=$TMPDIR;
      '';
      doChehck = true;
      checkPhase = ''
        runHook preCheck
        ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
        runHHook postCheck
      '';
    };

in {
  options.modules.develop.zig = {
    enable = mkBoolOpt false;
    llvm = mkOption {
      description = "LLVM version to compile zig with (min required is 14)";
      default = 14;
      example = 14;
      apply = toString;
      type = types.int;
    };
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
        zig
      ];
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
