{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.terminal.zellij;
  configDir = config.snowflake.configDir;
  themeCfg = config.modules.themes;
in {
  options.modules.desktop.terminal.zellij = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hm.programs.zellij = (mkMerge [
      {
        enable = true;
      }
    ]);
  };
}
