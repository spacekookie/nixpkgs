/* LONGER NEOMUTT PARAMETER LISTS PATCH
 *
 * Because of how my neomutt config handles GPG
 * encryption, neomutt needs to be patched to
 * allow for a longer argument buffer.
 * Luckily someone had already written a patch
 * for this, so I didn't have to :)
 */
{ pkgs, ... }:

pkgs.neomutt.overrideAttrs ({ patches ? [], ... }: {
  patches = patches ++ [ ./1388.patch ];
})
