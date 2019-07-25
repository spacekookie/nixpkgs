{ stdenv, python2, python2Packages, ... }:

python2.pkgs.buildPythonApplication rec {
  pname = "nodemcu-uploader";
  version = "0.4.3";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "13nlc2gr85pw7kcfirzi3k8rqybmdwhsxnndixvayis1fm80bsrf";
  };

  propagatedBuildInputs = with python2.pkgs; [ pyserial wrapt ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Lalalala";
    homepage = https://www.foo.org;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ spacekookie ];
  };
}
