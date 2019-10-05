/* HARDWARE SUPPORT MODULE
 *
 * This module doesn't include ALL submodules because
 * some are only relevant for specific platforms. Still
 * the general support should be provided by the
 * WORKSTATION module, not be bound to be device specific
 */

{ ... }:

{
  imports = [
    ./yubikey
    ./xkblayout
  ];
}
