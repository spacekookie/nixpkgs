{ config, lib, pkgs, ... }:

let
  cfg = config.libkookie;
in
{
  options.libkookie.activeUsers = with lib; mkOption {
    type = with types; listOf str;
    default = [];
    description = ''
      List of active users on this system.  This is relevant for what 
      userspace tools get installed, and what SSH pubkeys are included.
    '';
  };

  config = {
    users.mutableUsers = false;
    users.users = (with lib;
      let 
        pathify = name: builtins.toPath ./. ("/" + name + ".nix");
        include = path: import path { inherit pkgs lib; };
      in 
        listToAttrs (map
          (name: nameValuePair name (include (pathify name)))
          cfg.activeUsers));
  };
}
