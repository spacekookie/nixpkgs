/* ONIONS ARE REALLY GOOD
 *
 * This module is not included by default and is somewhat specific 
 * to the hyperion root server
 * 
 * TODO: make this a function that allows pasing a hostname and 
 * more specific settings
 */

{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 143 ];
  
  services.tor = {
    enable = true;
    relay = {
      enable = true;
      role = "relay";
      nickname = "hyp3rion";
      port = 143;
    };
  };
}
