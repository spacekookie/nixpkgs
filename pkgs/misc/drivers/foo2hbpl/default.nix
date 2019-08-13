{ stdenv, fetchurl, bash, bc, foomatic-filters, ghostscript,
  glibc, groff, linux, tix }:

stdenv.mkDerivation rec {
  pname = "foo2hbpl2";
  version = "2019-08-13";

  src = fetchurl {
    url = "http://foo2zjs.rkkda.com/foo2zjs.tar.gz";
    sha256 = "13gzsd26nq4brx1xzpwmg1qnr4nk7ykgi94qr1hbjqfi561prki4";
  };

  buildInputs = [ bc foomatic-filters ghostscript groff linux.dev stdenv tix ];

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR=$(out)"
  ];

  preBuild = ''
    sed -i "s@/usr/include/stdio.h@${glibc.dev}/include/stdio.h@" Makefile
    find ./ -type f -exec sed -i -e "s@/bin/bash@${bash}/bin/bash@g" {} \;
  '';

  meta = with stdenv.lib; {
    description = "ZjStream printer drivers";
    maintainers = [ maintainers.spacekookie ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
