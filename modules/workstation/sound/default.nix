{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio = let
    bt = config.hardware.bluetooth.enable;
  in
    with pkgs;
    {
      enable = true;
      zeroconf.discovery.enable = true; 

      # If a computer has bluetooth enabled, we want to pull in the
      # "big" pulseaudio package that includes bluetooth support.
      package = if bt then pulseaudioFull else pulseaudio;
      extraModules = if bt then [ pulseaudio-modules-bt ] else [];
    };
}
  
