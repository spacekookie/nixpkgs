/* USERSPACE MAIL CONFIGURATION
 *
 * This module depends on the `ext` hook in the repo
 * root, because it includes private config files
 * that contain sensitive information.
 */

{ pkgs, ... }:

{
  home.packages = with pkgs; [ neomutt notmuch ];
#   imports = [
#     ../../../ext/mail/neomutt.nix
#     ../../../ext/mail/notmuch.nix
#   ];
}
