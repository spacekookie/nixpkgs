{ overlays ? [] } @ args:

import ./nixpkgs (args // {
  overlays = [ (import ./overlays) ] ++ overlays;
})

