{ ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";
  users.users.spacekookie.extraGroups = [ "docker" ];
}
