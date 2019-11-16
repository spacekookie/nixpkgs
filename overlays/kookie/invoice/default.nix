{ stdenv, makeWrapper, coreutils, findutils,
  gawk, pandoc, gnumake, texlive }:

stdenv.mkDerivation {
  pname = "invoice";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp invoice.sh $out/bin/invoice
    cp template.tex $out/share/

    wrapProgram $out/bin/invoice \
      --set PATH $out/bin:${stdenv.lib.makeBinPath
        [ coreutils findutils gawk gnumake pandoc texlive.combined.scheme-full ]} \
      --set TEMPLATE_FILE $out/share/template.tex
  '';


  meta = with stdenv.lib; {
    description = "Generate dynamic invoices based on yaml descriptors";
    homepage = "https://git.sr.ht/~spacekookie/libkookie/";
    license = licenses.gpl3;
  };
}

