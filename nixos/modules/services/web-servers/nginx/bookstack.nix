{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bookstack;

  bookstackEnv = pkgs.writeText "env" ''
    # Environment
    APP_ENV=production
    APP_DEBUG=false
    APP_KEY=${cfg.appKey}
    APP_URL=${cfg.appUrl}

    # Database details
    DB_HOST=${cfg.dbHost}
    DB_DATABASE=${cfg.dbName}
    DB_USERNAME=${cfg.dbUser}
    DB_PASSWORD=${cfg.dbPw}

    # Cache and session
    CACHE_DRIVER=file
    SESSION_DRIVER=file
    # If using Memcached, comment the above and uncomment these
    #CACHE_DRIVER=memcached
    #SESSION_DRIVER=memcached
    QUEUE_DRIVER=sync

    # Memcached settings
    # If using a UNIX socket path for the host, set the port to 0
    # This follows the following format: HOST:PORT:WEIGHT
    # For multiple servers separate with a comma
    MEMCACHED_SERVERS=127.0.0.1:11211:100

    # Storage
    STORAGE_TYPE=local
    # Amazon S3 Config
    STORAGE_S3_KEY=false
    STORAGE_S3_SECRET=false
    STORAGE_S3_REGION=false
    STORAGE_S3_BUCKET=false
    # Storage URL
    # Used to prefix image urls for when using custom domains/cdns
    STORAGE_URL=false

    # General auth
    AUTH_METHOD=standard

    # Social Authentication information. Defaults as off.
    GITHUB_APP_ID=false
    GITHUB_APP_SECRET=false
    GOOGLE_APP_ID=false
    GOOGLE_APP_SECRET=false
    OKTA_BASE_URL=false
    OKTA_KEY=false
    OKTA_SECRET=false

    # External services such as Gravatar
    DISABLE_EXTERNAL_SERVICES=false

    # LDAP Settings
    LDAP_SERVER=false
    LDAP_BASE_DN=false
    LDAP_DN=false
    LDAP_PASS=false
    LDAP_USER_FILTER=false
    LDAP_VERSION=false

    # Mail settings
    MAIL_DRIVER=smtp
    MAIL_HOST=localhost
    MAIL_PORT=1025
    MAIL_USERNAME=null
    MAIL_PASSWORD=null
    MAIL_ENCRYPTION=null
  '';

  bookstackRoot = pkgs.stdenv.mkDerivation rec {
    name = "bookstack";
    nativeBuildInputs = with pkgs; [ php ];
    src = cfg.package;
    installPhase = ''
      mkdir -p $out
      cp -r ${bookstackDeps}/vendor $out/vendor
      cp -r * $out/

      # We need to copy and make writable the generated file
      #   because the PHP toolchain wants to write into it
      cp ${bookstackEnv} $out/.env
      chmod +w $out/.env

      cd $out
      php artisan key:generate
      php artisan storage:link

      # php artisan migrate
      # php artisan horizon
    '';
  };

  bookstackDeps = pkgs.stdenv.mkDerivation rec {
    name = "bookstack-deps";
    src = cfg.package;
    nativeBuildInputs = with pkgs; [ php phpPackages.composer ];
    buildPhase = ''
      composer install
    '';
    installPhase = ''
      mkdir -p $out
      cp -r vendor/ $out/
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0000000000000000000000000000000000000000000000000000";
  };

in

{
  options = {
    services.bookstack = {
      enable = mkEnableOption "bookstack";

      package = mkOption {
        type = types.path;
        default = pkgs.bookstack;
        description = "Path to the bookstack sources";
      };

      appDomain = mkOption {
        type = types.str;
        description = "The application domain";
      };

      appKey = mkOption {
        type = types.str;
        description = "Secret application key";
      };

      appUrl = mkOption {
        type = types.str;
        description = "The route under which bookstack will be served";
      };

      dbHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The database host";
      };

      dbName = mkOption {
        type = types.str;
        default = "bookstack";
        description = "The database name";
      };

      dbUser = mkOption {
        type = types.str;
        default = "bookstack";
        description = "The database username";
      };

      dbPw = mkOption {
        type = types.str;
        description = "The database password";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ bookstackRoot ];

    # TODO: Use a unix socket or a random port?
    services.phpfpm.poolConfigs.bookstack = ''
      listen = 127.0.0.1:40123
      user = ${cfg.dbUser}
      pm = dynamic
      pm.max_children = 64
      pm.start_servers = 10
      pm.min_spare_servers = 5
      pm.max_spare_servers = 20
      pm.max_requests = 500
    '';

    users.users.bookstack = mkIf (cfg.dbUsername == "bookstack") {};
    services.nginx.virtualHosts."${cfg.appDomain}" = {
      enableACME = true;
      forceSSL = true;
      root = "${bookstackRoot}/public";
      locations."/".index = "index.php index.html";
      locations."~ \.php$".extraConfig = ''
        fastcgi_pass 127.0.0.1:40123;
      '';
    };

    services.mysql = {
      ensureUsers = [ {
        ensurePermissions = {
          "${cfg.dbUser}.*" = "ALL PRIVILEGES";
        };
        name = "${cfg.dbUser}";
      } ];
    };

  };
}