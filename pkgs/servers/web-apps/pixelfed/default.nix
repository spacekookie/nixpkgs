{ lib, fetchFromGitHub }: fetchFromGitHub {
  owner = "pixelfed";
  repo = "pixelfed";
  rev = "v0.7.6";
  sha256 = "0662yvhpp2wim8r3k2a00fb8nmra3w1hnwxv3ddmw2czns80r9y5";
  meta = with lib; {
    description = "Federated Image Sharing";
    license = licenses.agpl3;
    homepage = https://github.com/pixelfed/pixelfed;
    maintainers = [ maintainers.spacekookie ];
  };
}

