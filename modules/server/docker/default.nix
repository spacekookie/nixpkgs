/* SERVER DOCKER SETTINGS
 *
 * A server can run docker containers, that might need some
 * more specific settings and options. These are defined here.
 *
 */

{ ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

}
