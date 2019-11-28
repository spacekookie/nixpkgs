/* TOP LEVEL DEVICE CONFIGURATION FOR
 * 
 *    hyperion (Hetzner EX41 root server)
 *
 * This file only contains settings that are specific to this one
 * device (hardware and things outside of nix, like partitions).
 *
 * This file is part of LIBKOOKIE, a collection of nix expressions.
 * LIBKOOKIE is licensed under the GPL-3.0 (or later) -- see LICENSE
 */

{ lib, config, pkgs, ... }:

{
  imports = [
    # General machine base setup
    <home-manager/nixos>
    ../modules/nix
    ../modules/base

    # Server base setup
    ../modules/server
    ../modules/server/nginx

    # Modules enabled on this server
    ../modules/server/blog
    #../modules/server/gitlab-ci
    ../modules/server/prosody
    ../modules/server/quassel
    #../modules/server/syncthing
    ../modules/server/tor

    # Define allowed ssh users
    #../modules/users/spacekookie
    #../modules/users/qyliss
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;

  boot.loader.grub.efiSupport = false;
  boot.zfs.devNodes = "/dev";
  boot.loader.grub.zfsSupport = true;
  boot.loader.grub.device = "/dev/sdb";

  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    dhcpcd.enable = false;
    defaultGateway = "95.216.98.1";
    nameservers = [ "1.1.1.1" ];
    interfaces.enp0s31f6 = {
      ipv4.addresses = [ { address = "95.216.98.55"; prefixLength = 26; } ];
    };

    # NAT settings for wireguard
    nat.enable = true;
    nat.externalInterface = "eth0";
    nat.internalInterfaces = [ "intranet" ];
  };

  networking.hostName = "hyperion"; # Define your hostname.
  networking.hostId = "d83bebd1";

  networking.wireguard.interfaces."intranet" = {
    ips = [ "10.13.12.1" ];
    listenPort = 51820;
    privateKeyFile = "/var/lib/wireguard/keys/private";

    peers = [
      { publicKey = "NHMpnZW6h/MwxWcjztpwH5NN44jS9lB1b5T5jby1i1A=";
        allowedIPs = [ "10.13.12.2/32" ]; }
      { publicKey = "U/EmC6uMGqrLOd+lqfquDcUShPHgoulN35Dan6RAqyU=";
        allowedIPs = [ "10.13.12.3/32" ]; }
      { publicKey = "yh8gU4otkndmSsVBuaPMxxFHem45FE3POvSAWi8LEik=";
        allowedIPs = [ "10.13.12.4/32" ]; }

      { publicKey = "cPvj0SPITg1twz3DprtQgehJDOAhOL/hnXlB5ZS6Fi4=";
        endpoint = "85.119.82.108:51820";
        allowedIPs = [ "10.172.171.0/24" ]; }
    ];
  };
  
  # FIXME: Change this, but I wanna know what will break first
  time.timeZone = "Europe/Berlin";

  # TODO: Should this be in here or `users` root?
  users.mutableUsers = false;
  system.stateVersion = "19.03";
}
