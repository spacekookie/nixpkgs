{ fetchFromGitHub, lib } : fetchFromGitHub {
  owner = "BookStackApp";
  repo = "BookStack";
  rev = "v0.26.1";
  sha256 = "0izw4sk1shbx31r2j9lw5dnwfasqfb1m8fdyxwajlhxrhzk9klra";
  meta = {
    homepage = https://bookstackapp.com;
    description = "A platform to create documentation/wiki content built with PHP & Laravel";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.spacekookie ];
  };
}
