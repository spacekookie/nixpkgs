{ lib, writeText, runCommand, writeReferencesToFile }:

{
  buildContainer =
    { cmd
    , mounts ? []
    , os ? "linux"
    , arch ? "x86_64"
    , readonly ? false
    }:
  let
    sysMounts = [
        { destination = "/proc";
          type = "proc";
          source = "proc"; }
        { destination = "/dev";
          type = "tmpfs";
          source = "tmpfs";
          options = [ "nosuid" "strictatime" "mode=755" "size=65536k" ]; }
        { destination = "/dev/pts";
          type = "devpts";
          source = "devpts";
          options = [ "nosuid" "noexec" "newinstance" "ptmxmode=0666" "mode=755" "gid=5" ]; }
        { destination = "/dev/shm";
          type = "tmpfs";
          source = "shm";
          options = [ "nosuid" "noexec" "nodev" "mode=1777" "size=65536k" ]; }
        { destination = "/dev/mqueue";
          type = "mqueue";
          source = "mqueue";
          options = [ "nosuid" "noexec" "nodev" ]; }
        { destination = "/sys";
          type = "sysfs";
          source = "sysfs";
          options = [ "nosuid" "noexec" "nodev" "ro" ]; }
        { destination = "/sys/fs/cgroup";
          type = "cgroup";
          source = "cgroup";
          options = [ "nosuid" "noexec" "nodev" "realatime" "ro" ]; }
    ];
    config = writeText "config.json" (builtins.toJSON {
      ociVersion = "1.0.0";
      platform = {
        inherit os arch;
      };

      linux = {
        namespaces = map (type: { inherit type; }) [ "pid" "network" "mount" "ipc" "uts" ];
      };

      root = { path = "rootfs"; inherit readonly; };

      process = {
        user = { uid = 0; gid = 0; };
        args = [ cmd.outPath ];
        cwd = "/";
      };

      mounts = map ({ destination, type, source, options ? null }: {
        inherit destination type source options;
      }) sysMounts ++ mounts;
    });
  in
    runCommand "join" {} ''
      set -o pipefail
      mkdir -p $out/rootfs/{dev,proc,sys}
      cp ${config} $out/config.json
      xargs tar c < ${writeReferencesToFile cmd} | tar -xC $out/rootfs/
    '';
}

