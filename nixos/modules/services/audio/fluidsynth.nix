{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.fluidsynth;

  pulse = config.hardware.pulseaudio;

  systemWide = !pulse.enable || (pulse.enable && pulse.systemWide);

  flags = escapeShellArgs ([ "-s" "-i" "-a" cfg.driver ] ++ cfg.extraFlags ++ cfg.soundFonts);

in {

  ###### interface

  options = {

    services.fluidsynth = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable FluidSynth, a software MIDI synthesizer daemon.
        '';
      };

      systemWide = mkOption {
        type = types.bool;
        description = ''
	  If set, <command>fluidsynth</command> will be started as a
          system-wide daemon.
        '';
      };

      soundFonts = mkOption {
        type = types.listOf types.path;
        description = ''
          Paths to sound fonts.
        '';
      };

      driver = mkOption {
        type = types.enum [ "alsa" "jack" "oss" "pulseaudio" ];
        description = ''
          Audio driver to use.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra flags for FluidSynth daemon command line.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.fluidsynth = {
      soundFonts = mkDefault [ "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2" ];
      driver = mkDefault (if pulse.enable then "pulseaudio" else "alsa");
    };

    systemd =
      let
        common = {
          serviceConfig = {
            ExecStart = "${pkgs.fluidsynth}/bin/fluidsynth ${flags}";
            Restart = "on-failure";
            RestartSec = "500ms";
          };
        };
      in if systemWide
      then {
        services.fluidsynth = common // {
          wantedBy = [ "sound.target" ];
          before = [ "sound.target" ];
          after = mkIf pulse.enable [ "pulseaudio.service" ];
          serviceConfig = common.serviceConfig // {
            User = "nobody";
            Group = "nobody";
          };
        };
      }
      else {
        user.services.fluidsynth = common // {
          wantedBy = [ "default.target" ];
          after = mkIf pulse.enable [ "pulseaudio.socket" ];
        };
      };

  };

}
