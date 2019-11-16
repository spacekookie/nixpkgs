{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mullvad-vpn;
  dir = "/var/lib/mullvad-vpn";
in
{
  options.services.mullvad-vpn = {
    enable = mkEnableOption "the Mullvad VPN daemon";
  };

  config = mkIf cfg.enable {
    systemd.services."mullvad-vpn" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      environment = 
        {
          MULLVAD_SETTINGS_DIR = "${dir}";
          # MULLVAD_RPC_SOCKET_PATH = "${dir}";
        };
      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "${dir}";
        ExecStart = ''
          ${pkgs.mullvad-vpn}/bin/mullvad-daemon --disable-log-to-file
        '';
      };
    };
  };
}
