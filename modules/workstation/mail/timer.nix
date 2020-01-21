{ pkgs, config, ... }:

let
  startISync = pkgs.writeShellScriptBin "start-isync" ''
    systemctl start isync.service
  '';
in
{
  # Might want to run mbsync manually
  environment.systemPackages = with pkgs; [ isync startISync ];

  # Setup spacekookie-mail user
  users.users.spacekookie-mail = {
    createHome = true;
    group = "spacekookie";
    home = "/var/lib/spacekookie-mail";
  };
  
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
            ${sudo}/bin/sudo -u spacekookie \
              ${notmuch}/bin/notmuch new
      '';
    };

  systemd.timers.isync = {
    timerConfig.Unit = "isync.service";
    timerConfig.OnCalendar = "*:0/5";
    timerConfig.Persistent = "true";
    after = [ "network-online.target" ];
    wantedBy = [ "timers.target" ];
  };

  # This sudoers rule allows anyone in the wheel group to run this
  # particular command without a password. Make sure that 'startISync'
  # is present in a path (environment.systemPackages above)!
  security.sudo.extraRules = [
    { commands = [ { command = "${startISync}/bin/start-isync";
                     options = [ "NOPASSWD" ]; } ];
      groups = [ "wheel" ];  }
  ];
}
