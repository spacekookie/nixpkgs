/* USERSPACE MAIL CONFIGURATION
 *
 * This module depends on the `ext` hook in the repo
 * root, because it includes private config files
 * that contain sensitive information.
 */

{ pkgs, ... }:

{
  home.packages = with pkgs; [ msmtp neomutt notmuch thunderbird ];
#   imports = [
#     ../../../ext/mail/neomutt.nix
#     ../../../ext/mail/notmuch.nix
#   ];
}
