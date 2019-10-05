/* TOP LEVEL DEVICE CONFIGURATION FOR
 * 
 *    uwu (Thinkpad X230)
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
    <home-manager/nixos>
    ../modules/workstation
  ];
  
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" "sdhci_pci" ];
  
  boot.loader.grub = {
    copyKernels = true;
    device = "/dev/sda";
    zfsSupport = true;
    enableCryptodisk = true;
  };

  boot.extraModprobeConfig = "options kvm_item nested=1";
  boot.zfs.devNodes = "/dev"; # FIXME: Why do I set this?
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
  boot.supportedFilesystems = [ "zfs" "exfat" ];

  fileSystems."/" = {
    device = "zroot";
    fsType = "zfs";

    encrypted = {
      enable = true;
      label = "lvm";
      blkDev = "/dev/disk/by-uuid/f1440abd-99e3-46a8-aa36-7824972fee54";
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/672c497c-18aa-4b00-ac95-78e810363d81";
    fsType = "ext3";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/bd3d5c22-eed0-4371-ae25-456b8dfe9356"; }
  ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # owo
  networking.hostName = "uwu";
  networking.hostId = "a82ecf29";
  networking.wireguard.interfaces."intranet" = {
    ips = [ "10.13.12.3" ];
    privateKeyFile = "/var/lib/wg/private";
    peers = [
      { publicKey = "ugHG/NOqM/9hde9EmWpu7XsCpjT3WQbjLK99IGHtdjQ=";
        allowedIPs = [ "10.13.12.0/24" "10.172.171.0/24" ];
        endpoint = "hyperion.kookie.space:51820";
        persistentKeepalive = 25; }
    ];
  };

  system.stateVersion = "19.03";
  users.users.spacekookie.hashedPassword = "$6$rounds=1000000$22ypycQ2AlCCv8iC$RrzyAbCX3D518nCgfR3MTqZhfK.GAclme7EQlKTlqH4oV1YvGd/aHdTfe59iMpf/J18tqEO2aSXsevTVQz2yW.";
  
}
