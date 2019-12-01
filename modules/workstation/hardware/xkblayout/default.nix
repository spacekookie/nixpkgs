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

  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:hyper";

    # We want to set this layout modification as a per-device setting
    # to avoid interpreting hardware keyboards with the same
    # layout, which would otherwise lead to "double dvorak".
    extraConfig = ''
      Section "InputClass"
        Identifier "Internal Keyboard"
        MatchIsKeyboard "yes"
        MatchProduct "AT Translated Set 2 keyboard"
        Option "XkbLayout"  "dvorak"
        Option "XkbVariant" "altgr-intl"
        Option "XkbOptions" "caps:hyper"
      EndSection
    '';
  };  
}
