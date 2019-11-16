{ config, pkgs, ... }:

let
  git = (pkgs.git.override { svnSupport = true; sendEmailSupport = true; });
in
{
  environment.systemPackages = [ git ] ++
                               (with pkgs.gitAndTools;
                                 [ hub git-remote-hg ]);
}
