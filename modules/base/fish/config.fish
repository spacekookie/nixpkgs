# source $HOME/.cargo/env
# set -gx PATH $HOME/.cargo/bin $PATH

# The o bit is a bit of a hack
# umask u=rw,g=rw,o-rwx

# direnv hook fish | source

# gnome-keyring insists on setting this to itself, even if ssh support is disabled
set -x SSH_AUTH_SOCK "/run/user/1000/gnupg/S.gpg-agent.ssh"

# Fix some utf-8 errors
set -x LC_ALL en_GB.utf8

# Better nix-shell support!
any-nix-shell fish --info-right | source
 
# Make git use emacs
set -x EDITOR kak

# tuuuuuuuurbofish!
set fish_greeting 'Welcome to the '(set_color FF66CC)'::<>' (set_color normal)'...'
