{ stdenv, fetchurl, makeWrapper, jre8, which, gawk }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "neo4j";
  version = "3.5.11";

  src = fetchurl {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${version}-unix.tar.gz";
    sha256 = "0xk37rvb37rd7pwpv4ingmb2v6ad1kqka8ldmd16n89fqfvg5m2d";
  };

  buildInputs = [ makeWrapper jre8 which gawk ];


  installPhase = ''
    mkdir -p "$out/share/neo4j"
    cp -R * "$out/share/neo4j"

    mkdir -p "$out/bin"
    for NEO4J_SCRIPT in neo4j neo4j-admin neo4j-import cypher-shell
    do
        makeWrapper "$out/share/neo4j/bin/$NEO4J_SCRIPT" \
            "$out/bin/$NEO4J_SCRIPT" \
            --prefix PATH : "${stdenv.lib.makeBinPath [ jre8 which gawk ]}" \
            --set JAVA_HOME "$jre8"
    done
  '';

  meta = with stdenv.lib; {
    description = "A highly scalable, robust (fully ACID) native graph database";
    homepage = http://www.neo4j.org/;
    license = licenses.gpl3;

    maintainers = [ maintainers.offline ];
    platforms = stdenv.lib.platforms.unix;
  };
}
