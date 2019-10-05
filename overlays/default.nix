/* Overlays in LIBKOOKIE are split into three parts
 * 
 * patches: upstream but with cool stuff
 * staging: things that might become upstream
 * kookie: scripts and utils that won't leave LIBKOOKIE
 */

self: super:

with super; {

  barrel-blog = callPackage ./kookie/barrel-blog { };

  invoice = callPackage ./kookie/invoice { };

  spacekookie-de = callPackage ./kookie/spacekookie-de { };

} // {

  nodemcu-uploader = callPackage ./staging/nodemcu-uploader { };
  
  pleroma = callPackage ./staging/pleroma { };
  
} // {

  emacs-ergoemacs-mode = callPackage ./patches/emacs-ergoemacs-mode { };
  
  htop = callPackage ./patches/htop { };

  neomutt = callPackages ./patches/neomutt { };
}
