{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell;
in {
  options.modules.shell = {
    default = mkOption {
      type = with types; package;
      default = pkgs.nushell;
      description = "Default system shell";
      example = "bash";
    };
  };

  config = mkIf (cfg.default != null) {
    users.defaultUserShell = cfg.default;
    user.packages = with pkgs; [ nix-output-monitor inputs.nh.packages.x86_64-linux.default ];
  };
}
