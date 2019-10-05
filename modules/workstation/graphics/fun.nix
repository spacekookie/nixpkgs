{ pkgs, ... }:

{
  home.packages = with pkgs; [
    spotify
    steam
  ];
}
