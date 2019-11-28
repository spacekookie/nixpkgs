{ config, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";
}
