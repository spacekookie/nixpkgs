/* QUASSEL SERVER
 * 
 * Provides a convenient IRC bouncer, that logs messages into a
 * postgres database. This module depends on `nginx/acme` being loaded
 * to handle certificates
 */

{ pkgs, ... }:

{
  services.quassel = {
    enable = true;
    interfaces = [ "0.0.0.0" ];
    portNumber = 4242;
  };

  # quasselcore depends on Pgsql
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
  };
}
