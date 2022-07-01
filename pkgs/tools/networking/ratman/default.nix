{ lib
, fetchurl
, installShellFiles
, libsodium
, pkg-config
, protobuf
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "ratman";
  version = "0.4.0";

  src = fetchurl {
    url = "https://git.irde.st/we/irdest/-/archive/${pname}-${version}/irdest-${pname}-${version}.tar.gz";
    sha256 = "tTWPhHqexDELBgseP7O3pbW38seSzhFvo5eVvw9gQ7E=";
  };

  cargoSha256 = "Nsux0QblBtzlhLEgfKYvkQrOz8+oVd2pqT3CL8TnQEc=";

  nativeBuildInputs = [ protobuf pkg-config installShellFiles ];

  cargoBuildFlags = [ "--all-features" "-p" "ratman" ];
  cargoTestFlags = cargoBuildFlags;

  buildInputs = [ libsodium ];

  postInstall = ''
    installManPage docs/man/ratmand.1
  '';

  SODIUM_USE_PKG_CONFIG = 1;

  meta = with lib; {
    description = "A modular decentralised peer-to-peer packet router and associated tools";
    homepage = "https://git.irde.st/we/irdest";
    platforms = platforms.unix;
    license = licenses.agpl3;
    maintainers = with maintainers; [ spacekookie yuka ];
  };
}
