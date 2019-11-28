/* SPACEKOOKIE.DE BLOG WEBSITE
 *
 * Static website built with pelican and nix
 */

{ pkgs, ... }:

let
  webpkg = pkgs.spacekookie-de;
in
{
  services.nginx.virtualHosts."spacekookie.de" = {
    serverAliases = [ "www.spacekookie.de" ];
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      root = webpkg;
      index = "index.html";
    };

    # Provide the `downloads` directory from the store
    # TODO: Improve this to be more updatable
    locations."/downloads/" = {
      root = webpkg;
      extraConfig = ''
        autoindex on;
      '';
    };
  };
}
