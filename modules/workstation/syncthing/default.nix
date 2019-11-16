{ pkgs, ... }: {
  services.syncthing = {
    enable = true;
    dataDir = "/home/.local/syncthing/";
    user = "spacekookie";
    group = "spacekookie";
    openDefaultPorts = false;
    guiAddress = "127.0.0.1:1234";
  };
}
