# CKAN Arch Linux Package

Because I don't like the version in the AUR, here is my own PKGBUILD (and stuff) to install CKAN. It creates a wrapper script under /usr/bin/ and copies the rest of the sources into /opt/ckan.

It also provides a desktop file to /usr/share/applications/ as well as an icon to /usr/share/pixmaps

You can use this package by either cloning the entire repo or  using SVN!

```console
svn checkout https://github.com/spacekookie/stuff/trunk/ckan/
cd ckan/
makepkg -si
```
