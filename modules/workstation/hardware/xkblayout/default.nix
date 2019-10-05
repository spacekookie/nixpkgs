/* KEYBOARD LAYOUT MODULE
 *
 * (INCOMPLETE) Setup keyboard layout
 * and overrides. Currently this is
 * mostly handled by GRAPHICS/I3 but
 * should maybe be moved here?
 */
{ pkgs, config, ... }:

{
  i18n.consoleUseXkbConfig = true;
  services.xserver.layout = "us";

  # environment.variables.XKB_DEFAULT_LAYOUT = xcfg.layout;
  # environment.variables.XKB_DEFAULT_OPTIONS = xcfg.xkbOptions;
}
