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
  llvmCfg = config.modules.develop.llvm;
  codeCfg = config.modules.desktop.editors.vscodium;
  llvm.packages = pkgs."llvmPackages_${llvmCfg.version}";
  inherit (llvm.packages) stdenv;
  zig = zigpkgs.master;
  zig2 = with pkgs;
    stdenv.mkDerivation rec {
      name = "zig";
      src = inputs.zig;
      # https://github.com/ziglang/zig/issues/12218
      cmakeFlags = [ "-DZIG_STATIC_LIB=ON" "-DCMAKE_SKIP_BUILD_RPATH=ON" ];
      nativeBuildInputs = [ cmake ninja llvm.packages.llvm.dev ];
      buildInputs = [ libxml2 zlib ] ++ ([
        llvm.packages.libclang
        llvm.packages.lld
        llvm.packages.llvm
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
  gyro =
    pkgs.stdenv.mkDerivation rec {
      name = "gyro";
      src = inputs.gyro;
      nativeBuildInputs = [ zig ];
      buildPhase = ''
        export XDG_CACHE_HOME=$TMPDIR;
        zig build install -p $out -Drelease-safe
      '';
      installPhase = ''
        mkdir -pv $out/bin
      '';
    };
in {
  options.modules.develop.zig = {
    enable = mkBoolOpt false;
 };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = [
        zig
        gyro
      ];
    })

    (mkIf devCfg.enable {
      # TODO:
    })
  ];
}
