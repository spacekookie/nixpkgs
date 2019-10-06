/* BASE DEVEL TOOLS
 *
 * Any tool that should be present on a system,
 * without being required in a specific context
 */

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    curl
    gnupg
    wget
  ];
}
