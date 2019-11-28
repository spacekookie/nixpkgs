/* SSH SERVER DEFINITIONS
 *
 * This function sets up ssh and mosh, as well as
 * access via SSH to specific users defined in libkookie
 * `modules/users/`
 */

{ config, ... }:

{
  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;

    # This setting is important for emacs TRAMP paths
    permitRootLogin = "yes";
  };
}
