# source $HOME/.cargo/env
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH /usr/sbin $PATH
set -gx GRAAL_HOME ~/.local/share/graalvm/

# The o bit is a bit of a hack
umask u=rw,g=rw,o-rwx

# direnv hook fish | source

# gnome-keyring insists on setting this to itself, even if ssh support is disabled
set -x SSH_AUTH_SOCK "/run/user/1000/gnupg/S.gpg-agent.ssh"

# I work with web stuff sometimes :(
set -x NPM_PACKAGES "$HOME/.local/npm_packages"
set -gx PATH $NPM_PACKAGES/bin $PATH

# Fix some utf-8 errors
set -x LC_ALL en_GB.utf8
 
# Include the nix environment
# fenv source /home/spacekookie/.nix-profile/etc/profile.d/nix.sh

# Better nix-shell support!
any-nix-shell fish --info-right | source
 
# Make git use emacs
set -x EDITOR kak

# tuuuuuuuurbofish!
set fish_greeting 'Welcome to the '(set_color FF66CC)'::<>' (set_color normal)'...'
