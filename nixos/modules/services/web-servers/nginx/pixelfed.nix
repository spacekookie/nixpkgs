{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pixelfed;

  pixelfedEnv = pkgs.writeText "env" ''
      APP_NAME="${cfg.appName}"
      APP_ENV=local
      APP_KEY=${cfg.apiKey}
      APP_DEBUG=${builtins.toString cfg.debug}
      APP_URL=${cfg.appURL}

      ADMIN_DOMAIN=${cfg.adminDomain}
      APP_DOMAIN=${cfg.appDomain}

      LOG_CHANNEL=stack

      DB_CONNECTION=mysql
      DB_HOST=${cfg.dbHost}
      DB_PORT=${builtins.toString cfg.dbPort}
      DB_DATABASE=${cfg.dbName}
      DB_USERNAME=${cfg.dbUsername}
      DB_PASSWORD=${cfg.dbPassword}

      BROADCAST_DRIVER=log
      CACHE_DRIVER=redis
      SESSION_DRIVER=redis
      SESSION_LIFETIME=120
      QUEUE_DRIVER=redis

      REDIS_HOST=127.0.0.1
      REDIS_PASSWORD=null
      REDIS_PORT=6379

      MAIL_DRIVER=log
      MAIL_HOST=${cfg.emailHost}
      MAIL_PORT=2525
      MAIL_USERNAME=${cfg.emailUsername}
      MAIL_PASSWORD=${cfg.emailPassword}
      MAIL_ENCRYPTION=${cfg.emailEncryption}
      MAIL_FROM_ADDRESS="${cfg.email}"
      MAIL_FROM_NAME="${cfg.emailName}"

      SESSION_DOMAIN="${cfg.appDomain}"
      SESSION_SECURE_COOKIE=true
      API_BASE="/api/1/"
      API_SEARCH="/api/search"

      OPEN_REGISTRATION=true
      RECAPTCHA_ENABLED=false
      ENFORCE_EMAIL_VERIFICATION=true

      MAX_PHOTO_SIZE=15000
      MAX_CAPTION_LENGTH=150
      MAX_ALBUM_LENGTH=4

      MIX_PUSHER_APP_KEY="${cfg.pusherApiKey}"
      MIX_PUSHER_APP_CLUSTER="${cfg.pusherAppCluster}"
      MIX_APP_URL="${cfg.appURL}"
      MIX_API_BASE="${cfg.apiBase}"
la     MIX_API_SEARCH="${cfg.apiSearch}"
  '';

  pixelfedRoot = pkgs.stdenv.mkDerivation rec {
    name = "pixelfed";
    nativeBuildInputs = with pkgs; [ php ];
    src = cfg.package;
    installPhase = ''
      mkdir -p $out 
      cp -r ${pixelfedDeps}/vendor $out/vendor
      cp -r * $out/

      # We need to copy and make writable the generated file
      #   because the PHP toolchain wants to write into it
      cp ${pixelfedEnv} $out/.env
      chmod +w $out/.env

      cd $out
      php artisan key:generate
      php artisan storage:link

      # php artisan migrate
      # php artisan horizon
    '';
  };
  
  pixelfedDeps = pkgs.stdenv.mkDerivation rec {
    name = "pixelfed-deps";
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
    outputHash = "0j3zdzvxbb54z5gjc42f17q17vxr147pzla5farvb3dkh9djacc7";
  };

in

{
  options = {
    services.pixelfed = {
      enable = mkEnableOption "pixelfed";

      package = mkOption {
        type = types.path;
        default = pkgs.pixelfed;
        description = "Path to the pixelfed sources";
      };

      appName = mkOption {
        type = types.str;
        default = "Pixelfed";
        description = "Name of the application";
      };

      apiKey = mkOption {
        type = types.str;
        default = "";
        description = "Valid API key for the application";
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Run the application in debug mode";
      };

      appURL = mkOption {
        type = types.str;
        default = "http://localhost";
        description = "The application URL";
      };

      adminDomain = mkOption {
        type = types.str;
        default = "";
        description = "The admin domain";
      };

      appDomain = mkOption {
        type = types.str;
        description = "The application domain";
      };

      dbHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The database host";
      };

      dbPort = mkOption {
        type = types.int;
        default = 3306;
        description = "The database port";
      };

      dbName = mkOption {
        type = types.str;
        default = "pixelfed";
        description = "The database name";
      };

      dbUsername = mkOption {
        type = types.str;
        default = "pixelfed";
        description = "The database username";
      };

      dbPassword = mkOption {
        type = types.str;
        description = "The database password";
      };

      emailHost = mkOption {
        type = types.str;
        default = "";
        description = "The admin e-mail host";
      };

      emailUsername = mkOption {
        type = types.str;
        default = "";
        description = "The admin e-mail username";
      };

      emailPassword = mkOption {
        type = types.str;
        default = "";
        description = "The admin e-mail password";
      };

      emailEncryption = mkOption {
        type = types.str;
        default = "";
        description = "Optionally use admin e-mail encryption";
      };

      email = mkOption {
        type = types.str;
        default = "";
        description = ''
          The admin e-mail address
          Example: pixelfed@example.com
        '';
      };

      emailName = mkOption {
        type = types.str;
        default = "pixelfed";
        description = "Admin e-mail name";
      };

      pusherApiKey = mkOption {
        type = types.str;
        default = "";
        description = "Push services";
      };

      pusherAppCluster = mkOption {
        type = types.str;
        default = "";
        description = "Push services";
      };

      apiBase = mkOption {
        type = types.str;
        default = "";
        description = "Push services";
      };

      apiSearch = mkOption {
        type = types.str;
        default = "";
        description = "Push services";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pixelfedRoot ];

    # TODO: Use a unix socket or a random port?
    services.phpfpm.poolConfigs.pixelfed = ''
      listen = 127.0.0.1:40123
      user = ${cfg.dbUsername}
      pm = dynamic
      pm.max_children = 64
      pm.start_servers = 10
      pm.min_spare_servers = 5
      pm.max_spare_servers = 20
      pm.max_requests = 500
    '';

    users.users.pixelfed = mkIf (cfg.dbUsername == "pixelfed") {};
    services.nginx.virtualHosts."${cfg.appDomain}" = {
      enableACME = true;
      forceSSL = true;
      root = "${pixelfedRoot}/public";
      locations."/".index = "index.php index.html";
      locations."~ \.php$".extraConfig = ''
        fastcgi_pass 127.0.0.1:40123;
      '';
    };
  
    services.mysql = {
      ensureUsers = [ {
        ensurePermissions = {
          "${cfg.dbUsername}.*" = "ALL PRIVILEGES"; 
        }; 
        name = "${cfg.dbUsername}";
      } ];     
    };

  };
}
