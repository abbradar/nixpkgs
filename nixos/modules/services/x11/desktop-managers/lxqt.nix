{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.lxqt;

in

{
  options = {

    services.xserver.desktopManager.lxqt.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the lxqt 0.9 desktop manager.";
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    services.xserver.desktopManager.session = singleton
      { name = "lxqt";
        start = ''
          exec ${pkgs.lxqt.lxqt-common}/bin/startlxqt
        '';
      };

    environment.systemPackages = [
      pkgs.kde5.oxygen-icons
      pkgs.hicolor_icon_theme
      #pkgs.lxqt.lxmenu-data
      pkgs.which
      #pkgs.libfm
      #pkgs.libfm.override { extraOnly = true; }
      #pkgs.lxqt.libqtxdg
      #pkgs.lxqt.liblxqt
      #pkgs.lxqt.liblxqt-mount
      pkgs.lxqt.lxqt-session
      pkgs.lxqt.lxqt-qtplugin
      pkgs.lxqt.lxqt-globalkeys
      pkgs.lxqt.lxqt-notificationd
      pkgs.lxqt.lxqt-about
      pkgs.lxqt.lxqt-common
      pkgs.lxqt.lxqt-config
      pkgs.lxqt.lxqt-openssh-askpass
      pkgs.lxqt.lxqt-panel
      pkgs.lxqt.lxqt-policykit
      pkgs.lxqt.lxqt-runner
      pkgs.lxqt.lxqt-session
      pkgs.lxqt.pcmanfm-qt
      pkgs.lxqt.lximage-qt
      #pkgs.lxqt.compton-conf
    ] ++ optional config.powerManagement.enable pkgs.lxqt.lxqt-powermanagement
      ++ optional config.services.xserver.windowManager.openbox.enable pkgs.lxqt.obconf-qt;

    # Link some extra directories in /run/current-system/software/share
    environment.pathsToLink =
      [ "/share/lxqt" "/share/desktop-directories" ];

    # Enable helpful DBus services.
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;

  };

# TODOs:
# - [ ] Let user select icon theme, rather than default to oxygen-icons, and then change etc/xdg/lxqt/lxqt.conf appropriately
}
