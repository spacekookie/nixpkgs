{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  cfg = config.programs.firefox;

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
    else ".mozilla";

  firefoxConfigPath =
    if isDarwin
    then "Library/Application Support/Firefox"
    else "${mozillaConfigPath}/firefox";

  profilesPath =
    if isDarwin
    then "${firefoxConfigPath}/Profiles"
    else firefoxConfigPath;

  extensionPath = "extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";

  profiles =
    flip mapAttrs' cfg.profiles (_: profile:
      nameValuePair "Profile${toString profile.id}" {
        Name = profile.name;
        Path =
          if isDarwin
          then "Profiles/${profile.path}"
          else profile.path;
        IsRelative = 1;
        Default = if profile.isDefault then 1 else 0;
      }
    ) // {
      General = {
        StartWithLastProfile = 1;
      };
    };

  profilesIni = generators.toINI {} profiles;

  mkUserJs = prefs: extraPrefs: ''
    // Generated by Home Manager.

    ${concatStrings (mapAttrsToList (name: value: ''
      user_pref("${name}", ${builtins.toJSON value});
    '') prefs)}

    ${extraPrefs}
  '';

in

{
  meta.maintainers = [ maintainers.rycee ];

  options = {
    programs.firefox = {
      enable = mkEnableOption "Firefox";

      package = mkOption {
        type = types.package;
        default =
          if versionAtLeast config.home.stateVersion "19.09"
          then pkgs.firefox
          else pkgs.firefox-unwrapped;
        defaultText = literalExample "pkgs.firefox";
        description = ''
          The Firefox package to use. If state version ≥ 19.09 then
          this should be a wrapped Firefox package. For earlier state
          versions it should be an unwrapped Firefox package.
        '';
      };

      extensions = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample ''
          with pkgs.nur.repos.rycee.firefox-addons; [
            https-everywhere
            privacy-badger
          ]
        '';
        description = ''
          List of Firefox add-on packages to install. Note, it is
          necessary to manually enable these extensions inside Firefox
          after the first installation.
        '';
      };

      profiles = mkOption {
        type = types.attrsOf (types.submodule ({config, name, ...}: {
          options = {
            name = mkOption {
              type = types.str;
              default = name;
              description = "Profile name.";
            };

            id = mkOption {
              type = types.ints.unsigned;
              default = 0;
              description = ''
                Profile ID. This should be set to a unique number per profile.
              '';
            };

            settings = mkOption {
              type = with types; attrsOf (either bool (either int str));
              default = {};
              example = literalExample ''
                {
                  "browser.startup.homepage" = "https://nixos.org";
                  "browser.search.region" = "GB";
                  "browser.search.isUS" = false;
                  "distribution.searchplugins.defaultLocale" = "en-GB";
                  "general.useragent.locale" = "en-GB";
                  "browser.bookmarks.showMobileBookmarks" = true;
                }
              '';
              description = "Attribute set of Firefox preferences.";
            };

            extraConfig = mkOption {
              type = types.lines;
              default = "";
              description = ''
                Extra preferences to add to <filename>user.js</filename>.
              '';
            };

            userChrome = mkOption {
              type = types.lines;
              default = "";
              description = "Custom Firefox CSS.";
              example = ''
                /* Hide tab bar in FF Quantum */
                @-moz-document url("chrome://browser/content/browser.xul") {
                  #TabsToolbar {
                    visibility: collapse !important;
                    margin-bottom: 21px !important;
                  }

                  #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
                    visibility: collapse !important;
                  }
                }
              '';
            };

            path = mkOption {
              type = types.str;
              default = name;
              description = "Profile path.";
            };

            isDefault = mkOption {
              type = types.bool;
              default = config.id == 0;
              defaultText = "true if profile ID is 0";
              description = "Whether this is a default profile.";
            };
          };
        }));
        default = {};
        description = "Attribute set of Firefox profiles.";
      };

      enableAdobeFlash = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the unfree Adobe Flash plugin.";
      };

      enableGoogleTalk = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the unfree Google Talk plugin. This option
          is <emphasis>deprecated</emphasis> and will only work if

          <programlisting language="nix">
          programs.firefox.package = pkgs.firefox-esr-52-unwrapped;
          </programlisting>

          and the <option>plugin.load_flash_only</option> Firefox
          option has been disabled.
        '';
      };

      enableIcedTea = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the Java applet plugin. This option is
          <emphasis>deprecated</emphasis> and will only work if

          <programlisting language="nix">
          programs.firefox.package = pkgs.firefox-esr-52-unwrapped;
          </programlisting>

          and the <option>plugin.load_flash_only</option> Firefox
          option has been disabled.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (
        let
          defaults =
            catAttrs "name" (filter (a: a.isDefault) (attrValues cfg.profiles));
        in {
          assertion = cfg.profiles == {} || length defaults == 1;
          message =
            "Must have exactly one default Firefox profile but found "
            + toString (length defaults)
            + optionalString (length defaults > 1)
                (", namely " + concatStringsSep ", " defaults);
        }
      )

      (
        let
          duplicates =
            filterAttrs (_: v: length v != 1)
            (zipAttrs
            (mapAttrsToList (n: v: { "${toString v.id}" = n; })
            (cfg.profiles)));

          mkMsg = n: v: "  - ID ${n} is used by ${concatStringsSep ", " v}";
        in {
          assertion = duplicates == {};
          message =
            "Must not have Firefox profiles with duplicate IDs but\n"
            + concatStringsSep "\n" (mapAttrsToList mkMsg duplicates);
        }
      )
    ];

    home.packages =
      let
        # The configuration expected by the Firefox wrapper.
        fcfg = {
          enableAdobeFlash = cfg.enableAdobeFlash;
          enableGoogleTalkPlugin = cfg.enableGoogleTalk;
          icedtea = cfg.enableIcedTea;
        };

        # A bit of hackery to force a config into the wrapper.
        browserName = cfg.package.browserName
          or (builtins.parseDrvName cfg.package.name).name;

        # The configuration expected by the Firefox wrapper builder.
        bcfg = setAttrByPath [browserName] fcfg;

        package =
          if isDarwin then
            cfg.package
          else if versionAtLeast config.home.stateVersion "19.09" then
            cfg.package.override { cfg = fcfg; }
          else
            (pkgs.wrapFirefox.override { config = bcfg; }) cfg.package { };
      in
        [ package ];

    home.file = mkMerge (
      [{
        "${mozillaConfigPath}/${extensionPath}" = mkIf (cfg.extensions != []) (
          let
            extensionsEnv = pkgs.buildEnv {
              name = "hm-firefox-extensions";
              paths = cfg.extensions;
            };
          in {
            source = "${extensionsEnv}/share/mozilla/${extensionPath}";
            recursive = true;
          }
        );

        "${firefoxConfigPath}/profiles.ini" = mkIf (cfg.profiles != {}) {
          text = profilesIni;
        };
      }]
      ++ flip mapAttrsToList cfg.profiles (_: profile: {
        "${profilesPath}/${profile.path}/chrome/userChrome.css" =
          mkIf (profile.userChrome != "") {
            text = profile.userChrome;
          };

        "${profilesPath}/${profile.path}/user.js" =
          mkIf (profile.settings != {} || profile.extraConfig != "") {
            text = mkUserJs profile.settings profile.extraConfig;
          };
      })
    );
  };
}
