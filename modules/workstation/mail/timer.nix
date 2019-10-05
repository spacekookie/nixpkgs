{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [ isync ];

  systemd.services.isync =
    let
      maildir = "${config.users.users.spacekookie.home}/office/mail";
      mbsyncrc = pkgs.writeText "mbsyncrc"
        (import ../../../ext/mail/mbsyncrc.nix { inherit maildir; });
    in with pkgs; {
      serviceConfig.Type = "oneshot";
      script = ''
        ${sudo}/bin/sudo -u spacekookie-mail \
        ${isync}/bin/mbsync -a -V -c ${mbsyncrc}
      '';
      postStart = ''
        ${findutils}/bin/find \
            "${maildir}" \
            \! -name .mbsyncstate* \
            \( \
              \( \! -user spacekookie -o \! -group spacekookie \) \
              -exec ${coreutils}/bin/chown spacekookie:spacekookie '{}' \; \
            , \
              -type f \! -perm 660 \
              -exec ${coreutils}/bin/chmod 0660 '{}' \; \
            , \
              -type d \! -perm 770 \
              -exec ${coreutils}/bin/chmod 0770 '{}' \; \
            \)
      '';
    };

  systemd.timers.isync = {
    timerConfig.Unit = "isync.service";
    timerConfig.OnCalendar = "*:0/5";
    timerConfig.Persistent = "true";
    after = [ "network-online.target" ];
    wantedBy = [ "timers.target" ];
  };
}
