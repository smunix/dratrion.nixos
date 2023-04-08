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
  cfg = config.modules.desktop.editors.neovim;
  nvimDir = "${config.snowflake.configDir}/nvim.d";
  colorscheme = config.modules.themes.neovim.theme;
in {
  options.modules.desktop.editors.neovim = {
    enable = mkBoolOpt false;
    ereshkigal.enable = mkBoolOpt false; # fnl
    agasaya.enable = mkBoolOpt false; # lua
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nixpkgs.overlays = with inputs; [nvim-nightly.overlay];

      user.packages = with pkgs; (mkMerge [
        (mkIf (!config.modules.develop.cc.enable) [gcc]) # Treesitter
      ]);

      hm.programs.neovim = {
        enable = true;
        package = pkgs.neovim-nightly;
        extraPackages = with pkgs; [neovide];
        withRuby = true;
        withPython3 = true;
        withNodeJs = true;
      };

      environment.shellAliases = {
        vi = "nvim";
        vim = "nvim";
        vdiff = "nvim -d";
      };
    }

    (mkIf (cfg.enable && cfg.agasaya.enable) {
      modules.develop.lua.enable = true;

      hm.programs.neovim = {
        # extraLuaPackages = (ps: with ps; [ luautf8 ]);
        extraConfig = ''
          luafile ${builtins.toString nvimDir + "/agasaya/init.lua"}
        '';
      };

      environment.variables = {
        SQLITE_PATH = "${pkgs.sqlite.out}/lib/libsqlite3.so";
        # MYVIMRC = "${nvimDir}/agasaya/init.lua";
      };
    })

    (mkIf (cfg.enable && cfg.ereshkigal.enable) {
      modules.develop.lua.fennel.enable = true;

      home.configFile."nvim" = {
        source = "${nvimDir}/ereshkigal";
        recursive = true;
      };
    })
  ]);
}
