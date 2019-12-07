{ lib, stdenv, fetchgit, python3Packages }:

stdenv.mkDerivation rec {
  name = "spacekookie.de";

  src = fetchgit {
    url = "https://git.sr.ht/~spacekookie/website";
    rev = "f6ca92954f6b825f933f685cb3c27990b96b1721";
    sha256 = "0414351da5hy1096lrmmpm2jwdrxb8j5v59ccz6ayzpv1vwxk5qd";
  }; 

  buildInputs = with python3Packages; [ pelican webassets markdown ];

  installPhase = ''
      pelican content
      cp -rv output $out
    '';

  meta = with stdenv.lib; {
    description = "The `about` and `blog` part of spacekookie.de";
    homepage = "https://spacekookie.de";
    license = licenses.mit;
  };
}

