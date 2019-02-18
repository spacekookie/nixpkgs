# source $HOME/.cargo/env
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH /usr/sbin $PATH

# gnome-keyring insists on setting this to itself, even if ssh support is disabled
set -x SSH_AUTH_SOCK "/run/user/1000/gnupg/S.gpg-agent.ssh"

# I work with web stuff sometimes :(
set -x NPM_PACKAGES "$HOME/.local/npm_packages"
set -gx PATH $NPM_PACKAGES/bin $PATH

# Fix some utf-8 errors
set -x LC_ALL en_GB.utf8
 
# Include the nix environment
# if not test $NIX_PATH
fenv source /home/spacekookie/.nix-profile/etc/profile.d/nix.sh
# end

# Make git use kakoune
set -x EDITOR kak

# Setting up bindings!
bind \cr __fancy_history

# tuuuuuuuurbofish!
set fish_greeting 'Welcome to the '(set_color FF66CC)'::<>' (set_color normal)'...'
