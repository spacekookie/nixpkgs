/* REAL-TIME COMMUNICATION CLIENTS
 *
 * A bit of a mix of applications and no real configuration
 */

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dino
    quasselClient
    signal-desktop
    weechat
  ];
}
