{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.mullvad-vpn ];

  networking = {
    networkmanager = {
      enable = true;

      # Plausible MAC randomization
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
      extraConfig = ''
        # Integrate networkmanager with resolvd
        rc-manager="resolvconf";

        [connection-extra]
        ethernet.generate-mac-address-mask=FE:FF:FF:00:00:00
        wifi.generate-mac-address-mask=FE:FF:FF:00:00:00
      '';
    };

    firewall.enable = true;
  };
}
