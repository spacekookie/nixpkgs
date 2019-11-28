/* NGINX ROOT CONFIGURATION
 *
 * Mostly sets up IP anonymisation in logs
 */

{ config, ... }:

{
  services.nginx = {
    enable = true;
    appendHttpConfig = ''
      map $remote_addr $remote_addr_anon {
        ~(?P<ip>\d+\.\d+\.\d+)\.    $ip.X;
        ~(?P<ip>[^:]+:[^:]+):       $ip::X;
        default                     0.0.0.0;
      }
    
      log_format anonymous '$remote_addr_anon - $remote_user [$time_local] '
                             '"$request" $status $body_bytes_sent '
                             '"$http_referer" "$http_user_agent"';
      access_log /var/spool/nginx/logs/access.log anonymous;
      charset UTF-8;
    '';
  };
}
