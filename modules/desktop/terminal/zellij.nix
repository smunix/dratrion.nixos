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
    home.configFile = {
      "fish/conf.d/zellij.fish".text = ''
        # Start Zellij on Fish start
        if status is-interactive && if ! set -q ZELLIJ
            exec zellij
            end
        end
      '';
    };
    hm.programs.zellij = (mkMerge [
      {
        enable = true;
      }
    ]);
  };
}
