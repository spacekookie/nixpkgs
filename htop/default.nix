{ pkgs, ... }:

{
  home.packages = [ 
    (pkgs.htop.overrideAttrs ({ src, patches ? [], nativeBuildInputs ? [], ... }: {
        src = pkgs.fetchFromGitHub {
          repo = "htop";
          owner = "hishamhm";
          rev = "402e46bb82964366746b86d77eb5afa69c279539";
          sha256 = "0akyspxl80h2kgp6nhbhnz9v5265pi6d57i6l90pf50l92z61sw7";
        };
        nativeBuildInputs = nativeBuildInputs ++ [ pkgs.autoreconfHook ];
        patches = patches ++ [ ./0001-htop-untruncated-username.patch ];
      }))
  ];
}
