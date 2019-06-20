# Kookie's computer thingamajiggies

This repository contains my nix library. It consists of different
modules that install, configure and start services in my userspace.
It also provides "packet namespaces" that install a range of software
that I deem useful. These "namespaces" can be configured on a
host-by-host basis, meaning that not all types of computers install
all software automatically (i.e. servers vs. laptops vs. desktop
workstations). All of this is done via [`home-manager`].

[`home-manager`]: https://github.com/rycee/home-manager

While most of the configuration done in this library only depends on
`home-manager` and `nixpkgs` directly, some might also require my
personal package repisitory [`kookiepkgs`]. You can disable this
dependency by not using the `kookiepkgs` namespace.

[`kookiepkgs`]: https://github.com/spacekookie/kookiepkgs

## Contributions

You're very welcome to steal things from this repository (note the
license though!)

If you see a way that this library or any of its components could be
improved, I'd also be very happy to accept PRs to it. And also, if
you have quesitons, just open an issue, or send me an e-mail!
