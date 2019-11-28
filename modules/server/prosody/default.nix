/* PROSODY XMPP SERVER
 * 
 * Convenient XMPP server with lots of XEP extentions, that also
 * sets up ACME certificates specifically for the XMPP domain
 */

{ config, pkgs, ... }:

let
  ssl = {
    cert = "/var/lib/acme/xmpp.spacekookie.de/fullchain.pem";
    key = "/var/lib/acme/xmpp.spacekookie.de/key.pem";
  };
in
{
  networking.firewall.allowedTCPPorts = [ 5222 5269 ];

  security.acme.certs."xmpp.spacekookie.de" = {
    email = "letsencrypt@spacekookie.de";
    webroot = "/var/lib/acme/acme-challenge";
    extraDomains = { 
      "spacekookie.de" = null;
    };
    user = "prosody";
  };

  services.prosody = {
    enable = true;
    modules = {
      register = false;
      http_files = true;
      carbons = true;
      mam = true;
      pep = true;
    };
    inherit ssl;
    virtualHosts."spacekookie.de" = { 
      domain = "spacekookie.de";
      enabled = true;
      inherit ssl;
    };
    package = pkgs.prosody.override {
      withCommunityModules = [ "http_upload" "smacks" "csi" "cloud_notify" ];
    };
    extraConfig = ''
      http_upload_file_size_limit = 0 -- No limit
    '';
  };
}
