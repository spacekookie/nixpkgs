{ config, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      extraConfig = ''
        rc-manager="resolvconf";
      '';
    };

    firewall.enable = true;
  };
}
