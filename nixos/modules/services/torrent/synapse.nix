{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.synapse;
in
{
  options = {
    services.synapse = {
      enable = mkEnableOption "synapse";

      configFile = mkOption {
        type = types.string;
        default = "/var/lib/synapse/config.toml";
        description = ''
          Specify a configuration file to load settings from
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.synapse = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.synapse-bt}/bin/synapse -c ${cfg.configFile}
        '';
      };
    };
  };
}
