/* TRACKPOINT INPUT CONFIGURATION
 *
 * This is a compatibility module for Thinkpad computers
 */

{ config, .... }: {
  services.xserver.libinput = {
    accelProfile = "flat";
    accelSpeed = "-0.2";
    scrollButton = 2;
  };

  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };
}
