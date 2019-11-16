/* Overlays in LIBKOOKIE are split into three parts
 * 
 * patches: upstream but with cool stuff
 * staging: things that might become upstream
 * kookie: scripts and utils that won't leave LIBKOOKIE
 */

self: super: {

  barrel-blog = self.callPackage ./kookie/barrel-blog { inherit (super); };
  invoice = self.callPackage ./kookie/invoice { inherit (super); };
  spacekookie-de = self.callPackage ./kookie/spacekookie-de { inherit (super); };

  nodemcu-uploader = self.callPackage ./staging/nodemcu-uploader { };
  pleroma = self.callPackage ./staging/pleroma { };
  
  emacs-ergoemacs-mode = self.callPackage ./patches/emacs-ergoemacs-mode { };
  htop = self.callPackage ./patches/htop { inherit (super) htop; };
  neomutt = self.callPackages ./patches/neomutt { inherit (super) neomutt; };
}
