/* TOP LEVEL DEVICE CONFIGURATION FOR
 * 
 *    tempst (AMD workstation)
 *
 * This file only contains settings that are specific to this one
 * device (hardware and things outside of nix, like partitions).
 *
 * This file is part of LIBKOOKIE, a collection of nix expressions.
 * LIBKOOKIE is licensed under the GPL-3.0 (or later) -- see LICENSE
 */

{ lib, config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    <home-manager/nixos>
    ../modules/nix
    ../modules/base
  ];
  
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  hardware.enableRedistributableFirmware = true;
  
  boot.loader.grub = {
    copyKernels = true;
    device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S2RBNB0J340787H";
    zfsSupport = true;
    enableCryptodisk = true;
  };

  boot.extraModprobeConfig = "options kvm_item nested=1";
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;
  boot.supportedFilesystems = [ "zfs" "exfat" ];

  fileSystems."/" = {
    device = "zroot";
    fsType = "zfs";

    encrypted = {
      enable = true;
      label = "lvm";
      blkDev = "/dev/disk/by-uuid/7444569c-3f9c-4870-89c2-efa2632f533d";
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/a5140cc3-08b9-4b5f-9854-aa97c47027b8";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/3ff907d0-5e9d-419e-bc98-41653b615725"; }
  ];

  nix.maxJobs = 16;
  i18n.consoleFont = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # The protagonist's ship in Mass Effect: Andromeda
  networking.hostName = "tempest";
  networking.hostId = "ef9611bf";

  system.stateVersion = "19.03";
  users.users.spacekookie.hashedPassword = "$6$rounds=1000000$SJCdQsnp.nL8r$ilM9bdZhxmHPT6mns0Z2sNtIxe4xBDi1.qLybNrDKZeeL8ctNHsF95F4QCvc0kQm4A1EMtwun5YStr4sSz8Yi/";
}
