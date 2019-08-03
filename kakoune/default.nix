{ pkgs, ... }:

{
  home.packages = [ pkgs.kakoune ];

  xdg.configFile."kak/" = {
    recursive = true;
    executable = false;
    source = ./.;
  };
}
