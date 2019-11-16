{ pkgs, wallpaper }:

{
  enable = true;
  package = pkgs.i3;
  config = rec {
    modifier = "Mod4";

    # Use iosevka as default font
    fonts = [ "iosevka-term-ss09 10" ];

    keybindings = {

      # Start a terminal
      "${modifier}+Return" = "exec ${pkgs.kitty}/bin/kitty";

      # Close individual windows
      "${modifier}+Shift+q" = "kill";

      # Full-screen window
      "${modifier}+f" = "fullscreen";

      # Start software on <this> or <other> workspace
      "${modifier}+d" = "exec dmenu_run";
      "${modifier}+Shift+d" = "exec ~/.config/i3/dynamic-tags/move.sh";

      # Move focus around - vim style
      "${modifier}+i" = "focus up";
      "${modifier}+j" = "focus left";
      "${modifier}+k" = "focus down";
      "${modifier}+l" = "focus right";

      # Move focus around - boring style
      "${modifier}+Up" = "focus up";
      "${modifier}+Down" = "focus down";
      "${modifier}+Left" = "focus left";
      "${modifier}+Right" = "focus right";

      # Move windows - vim style
      "${modifier}+Shift+i" = "move up";
      "${modifier}+Shift+j" = "move left";
      "${modifier}+Shift+k" = "move down";
      "${modifier}+Shift+l" = "move right";

      # Move windows - boring style
      "${modifier}+Shift+Up" = "move up";
      "${modifier}+Shift+Down" = "move down";
      "${modifier}+Shift+Left" = "move left";
      "${modifier}+Shift+Right" = "move right";

      # Move workspaces between multi-monitor setups
      "${modifier}+Ctrl+Shift+Up" = "move workspace to output up";
      "${modifier}+Ctrl+Shift+Down" = "move workspace to output down";
      "${modifier}+Ctrl+Shift+Left" = " move workspace to output left";
      "${modifier}+Ctrl+Shift+Right" = "move workspace to output right";

      # Define split behaviours
      "${modifier}+2" = "split h";
      "${modifier}+1" = "split v";

      # A very fortunate lockscreen
      "${modifier}+Ctrl+l" = "exec --no-startup-id i3lock -c 333333";
      "${modifier}+Ctrl+Shift+l" = "exec --no-startup-id systemctl hibernate";

      # Rename workspaces
      "${modifier}+Ctrl+r" = "exec i3-input -F 'rename workspace to \"%s\"' -P 'New name: '";

      # Switch to workspace (optionally dragging windows with)
      "${modifier}+s" = "exec ~/.config/i3/dynamic-tags/switch.sh -fn '$dfont'";
      "${modifier}+Shift+s" = "exec ~/.config/i3/dynamic-tags/move.sh -fn '$dfont'";

      # Some layout modifiers
      "${modifier}+e" = "layout default";
      "${modifier}+w" = "layout tabbed";
      "${modifier}+q" = "layout stacked";

      # Do I even use this?!
      "${modifier}+Shift+space" = "floating toggle";
      "${modifier}+space" = "focus mode_toggle";

      # Focus the parent containers
      "${modifier}+a" = "focus parent";

      # Audio is good actually
      "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
      "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
      "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";

      # Reload, restart and quit i3
      "${modifier}+Shift+c" = "reload";
      "${modifier}+Shift+r" = "restart";
      "${modifier}+Shift+e" = ''
        exec i3-nagbar -t warning -m "Workspaces are sentient, you know. \
        We just have a lot of them" "i3-msg exit"
      '';

      # Switch to resize mode (defined below)
      "${modifier}+r" = "mode \"resize\"";

      # FIXME: What was this again?!
      "button4" = "nop";
      "button5" = "nop";
    };

    modes = {

      # Explicitly handle the resize mode
      resize = {
        "h" = "resize shrink width 5 px or 5 ppt";
        "j" = "resize grow height 5 px or 5 ppt";
        "k" = "resize shrink height 5 px or 5 ppt";
        "l" = "resize grow width 5 px or 5 ppt";

        # same bindings, but for the arrow keys
        "Left" = "resize shrink width 5 px or 5 ppt";
        "Down" = "resize grow height 5 px or 5 ppt";
        "Up" = "resize shrink height 5 px or 5 ppt";
        "Right" = "resize grow width 5 px or 5 ppt";

        # back to normal: Enter or Escape or $mod+r
        "Return" = "mode \"default\"";
        "Escape" = "mode \"default\"";
        "${modifier}+r" = "mode \"default\"";
      } ;
    };

    # The `bars` module does weird stuff so we init it ourselves
    bars = [];
  };

  extraConfig = with pkgs; ''
    # Setup compton compositor
    exec_always --no-startup-id "${coreutils}/bin/pkill compton; ${compton}/bin/compton --config ~/.config/i3/compton.conf"

    # Make CAPSLOCK into ESC because it's 2018
    #
    # Okay actually this is slightly more complicated than that. Actually I'm
    # binding CAPSLOCK to HYPER, so that I can use it as a modifier in emacs,
    # but then using xcape(1) to also make short CAPSLOCK presses into ESCAPE.

    exec_always --no-startup-id "${xorg.xmodmap}/bin/setxkbmap -layout us -variant altgr-intl -option caps:hyper"
    exec ${xcape}/bin/xcape -e "#66=Escape" -t 150

    # Always set a wallpaper
    exec_always --no-startup-id ${feh}/bin/feh --bg-fill ${wallpaper}

    bar {
        status_command ${i3status}/bin/i3status -c ~/.config/i3/i3status.conf
        position bottom
        bindsym button4 nop
        bindsym button5 nop
        colors  {
            background #0F0F0F
            statusline #D5D5D5
        }
    }

    focus_follows_mouse no

    # Layout and design settings that should _really_ be in the module
    default_border pixel 3
    client.focused #4c7899 #285577 #ffffff #F73E5F #666666
  '';
}
