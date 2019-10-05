{ pkgs, ... }:

let
  git = (pkgs.git.override { svnSupport = true; sendEmailSupport = true; });
in
{
  home.packages = [ git ]
                  ++ (with pkgs; [ gitAndTools.hub ]);
}
