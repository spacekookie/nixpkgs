{ pkgs, ... }:
   
{
  home.packages = [ pkgs.podman ];

  xdg.configFile."podman/containers/libpod.conf" = {
    text = ''
      runtime_path = ["${pkgs.runc}/bin/runc"]
      conmon_path = ["${pkgs.conmon}/bin/conmon"]
    '';
  };

  xdg.configFile."podman/containers/policy.json" = {
    text = builtins.toJSON {
      default = [ { type = "insecureAcceptAnything"; } ];
    };
  };

  xdg.configFile."podman/containers/registries.conf" = {
    text = ''
      [registries.search]
      registries = ['docker.io']
    '';
  };

  xdg.configFile."podman/containers/storage.conf" = {
    text = ''
      [storage]
      driver = "zfs"
      runroot = "/tmp/1000"
      graphroot = "/home/.local/podman
    '';
  };

}
