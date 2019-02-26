{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.railcar;
  generateUnit = name: containerConfig:
    let
      container = pkgs.ociTools.buildContainer {
        cmd = containerConfig.cmd;
      };
    in
      nameValuePair "railcar-${name}" {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            ExecStart = ''
              ${cfg.package}/bin/railcar -r ${cfg.stateDir} run ${name} -b ${container}
            '';
            Type = containerConfig.runType;
          };
      };
in
{
  options.services.railcar = {
    enable = mkEnableOption "railcar";

    containers = mkOption {
      default = {};
      description = "Declarative container configuration";
      type = with types; loaOf (submodule ({ name, config, ... }: {
        options = {
          cmd = mkOption {
            type = types.string;
            description = "Command or script to run inside the container";
          };

          mounts = mkOption {
            type = with types; loaOf (path);
            default = [];
            description = "A set of mounted directories inside the container";
          };

          runType = mkOption {
            type = types.string;
            default = "oneshot";
            description = "The systemd service run type";
          };

          os = mkOption {
            type = types.string;
            default = "linux";
            description = "OS type of the container";
          };

          arch = mkOption {
            type = types.string;
            default = "x86_64";
            description = "Computer architecture type of the container";
          };
        };
      }));
    };

    stateDir = mkOption {
      type = types.path;
      default = ''/var/railcar'';
      description = "Railcar persistent state directory";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.railcar;
      description = "Railcar package to use";
    };
  };

  config = mkIf cfg.enable {
    systemd.services = flip mapAttrs' cfg.containers (name: containerConfig:
      generateUnit name containerConfig
    );
  };
}

