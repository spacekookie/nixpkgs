/* ADDITIONAL SHELL TOOLS
 *
 * This module is a bit hard to wrap your head around, not because of
 * what it does but because of the classification of tools it
 * contains. It's a list of various utilities that are super useful
 * for day-to-day use, but it's difficult to avoid just having one
 * large file that contains _all_ applications you would ever use.
 *
 * Only add stuff to this list if you're sure that it will be useful
 * on ALL workstations, as well as root-servers and user-servers!
 */

{ pkgs, ... }:

{
  home-manager.users.spacekookie = { ... }: {
    home.packages = with pkgs; [
      bat
      curl
      fzf
      htop
      kakoune # used to have a vim-type editor everywhere
      moreutils
      pciutils
      pv
      ripgrep
      skim
      tmux
      tree
      usbutils
      wget
    ];
  };
}
