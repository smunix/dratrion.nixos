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
  cfg = config.modules.shell.nushell;
  nushellCfg = "${config.snowflake.configDir}/nu";
in {
  options.modules.shell.nushell = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      any-nix-shell
      fzf
      pwgen
      yt-dlp

      # alternatives for several gnu-tools
      bottom
      inputs.devenv.packages.x86_64-linux.default
      exa
      fd
      (ripgrep.override {
        withPCRE2 = true;
      })
      zoxide
    ];

    hm.programs.nushell = {
      enable = true;
    };

  };
}
