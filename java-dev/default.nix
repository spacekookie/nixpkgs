{ pkgs, ... }:

{
  home.packages = with pkgs; [ eclipses.eclipse-java lombok ];
}
