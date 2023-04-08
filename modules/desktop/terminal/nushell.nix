{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.terminal.nushell;
  configDir = config.snowflake.configDir;
  themeCfg = config.modules.themes;
in {
  options.modules.desktop.terminal.nushell = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.nushell = (mkMerge [
      {
        enable = true;
      }
    ]);
  };
}
