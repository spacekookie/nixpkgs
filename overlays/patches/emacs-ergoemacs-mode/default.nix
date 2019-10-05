/* CUSTOM ERGOEMACS-MODE PATCH
 *
 * The ergonomic keybinding minor-mode I use in emacs
 * (ergoemacs) uses MENU as a modifier key. Instead
 * I would like to use HYPER.
 */
{ pkgs, ... }:

with pkgs.emacsPackagesNg;
ergoemacs-mode.overrideAttrs ({ patches ? [], ... }: {
  patches = patches ++ [ ./menu_to_hyper.patch ];
})
