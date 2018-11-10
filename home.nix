{ lib, pkgs, ... }:

{
  home.packages = [
    pkgs.fish
  ];

  # programs.fish.enable = true;
  # programs.fish.shellInit = import ./fish.nix;
  xdg.configFile."fish/config.fish".text = import ./fish.nix;
  xdg.configFile."fish/functions/__history_previous_command.fish".text = ''
    function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
        end
    end
  '';

  xdg.configFile."fish/functions/fish_user_key_bindings.fish".text = ''
    bind ! __history_previous_command
  '';

  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/master.tar.gz;
  };
}
