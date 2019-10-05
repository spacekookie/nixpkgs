/* JAVA DEVELOPMENT MODE
 *
 * FIXME: Integrate building libgdx/ lwjgl with nix
 */
{ pkgs, ... }: {
  home.packages = with pkgs; [ eclipses.eclipse-java lombok ];
}
