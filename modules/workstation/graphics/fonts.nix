{ pkgs, ... }:

# let
#   iosevka = (pkgs.iosevka.override {
#     design = [ "v-at-long"
#                "v-l-italic"
#                "v-asterisk-low"
#                "v-zero-dotted"
#                "v-dollar-open"
#                "v-numbersign-slanted" ];
#     upright = [ "v-i-hooky" ];
#     set = "iosevka-ss09-term";
#   });
# in
{
  fonts.fonts = with pkgs; [
    google-fonts
    inconsolata
    iosevka
    twitter-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    emoji = [ "Twitter Color Emoji" ];
    monospace = [ "Iosevka" ];
  };
}
