{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.octoprint;

in
{
  ##### interface

  options = {

    services.octoprint = {

      enable = mkEnableOption "OctoPrint, web interface for 3D printers";

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          Host to bind OctoPrint to.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 5000;
        description = ''
          Port to bind OctoPrint to.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "octoprint";
        description = "User for the daemon.";
      };

      group = mkOption {
        type = types.str;
        default = "octoprint";
        description = "Group for the daemon.";
      };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/octoprint";
        description = "State directory of the daemon.";
      };

    };

  };

  ##### implementation

  config = mkIf cfg.enable {

    users.extraUsers = optionalAttrs (cfg.user == "octoprint") (singleton
      { name = "octoprint";
        group = cfg.group;
        uid = config.ids.uids.octoprint;
      });

    users.extraGroups = optionalAttrs (cfg.group == "octoprint") (singleton
      { name = "octoprint";
        gid = config.ids.gids.octoprint;
      });

    systemd.services.octoprint = {
      description = "OctoPrint, web interface for 3D printers";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p "${cfg.stateDir}"
        chown -R ${cfg.user}:${cfg.group} "${cfg.stateDir}"
      '';

      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.octoprint}/bin/octoprint --host ${cfg.host} --port ${toString cfg.port} -b ${cfg.stateDir} -d";
        User = cfg.user;
        Group = cfg.group;
        PermissionsStartOnly = true;
      };
    };

  };

}
