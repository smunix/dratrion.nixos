{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.develop.haskell;
  devCfg = config.modules.develop.xdg;
  codeCfg = config.modules.desktop.editors.vscodium;
in {
  options.modules.develop.haskell = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs;
        [ghc]
        ++ (with haskellPackages; [
          cabal-install
          graphmod
          haskell-language-server
          hasktags
          hoogle
          hpack
          implicit-hie
          stylish-haskell
        ]);

      home.configFile = with config.snowflake; {
        "stylish-haskell/config.yaml" = {
          source = "${configDir}/formatters/stylish-haskell.yaml";
        };
      };
    })

    (mkIf codeCfg.enable {
      hm.programs.vscode.extensions = with pkgs.vscode-extensions; [
        haskell.haskell
        justusadam.language-haskell # syntax-highlighting
      ];
    })

    (mkIf devCfg.enable {
      # TODO:
    })
  ];
}
