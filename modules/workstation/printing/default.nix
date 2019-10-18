{ pkgs, ... }:

{
  services.avahi.enable = true;
  services.printing = {
    enable = true;
    # drivers = [ pkgs.foo2zjs ];
  };
}
  
