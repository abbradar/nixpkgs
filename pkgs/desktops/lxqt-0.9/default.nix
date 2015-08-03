{ pkgs, newScope }: let

callPackage = newScope (deps // lxqtSelf);

deps = rec { # lxqt-global dependency overrides should be here
#  inherit (pkgs.gnome) libglade libwnck vte gtksourceview;
#  inherit (pkgs.perlPackages) URI;
};

lxqtSelf = rec {

  #### NixOS support

  # Inputs for callPackage arguments
  inherit (pkgs.kde5) kwindowsystem kguiaddons;
  qt = pkgs.qt54;

  mkLxqt = super: pkgs.stdenv.mkDerivation (
    let version = "0.9.1";
        self = pkgs.lib.recursiveUpdate {
          name = "${self.basename}-${self.version}";
          lxqtBundled = true;

          src = super.src or (pkgs.fetchurl {
            url = if self.lxqtBundled
              then "http://downloads.lxqt.org/lxqt/${version}/${self.basename}-${self.version}.tar.xz"
              else "http://downloads.lxqt.org/${self.basename}/${self.version}/${self.basename}-${self.version}.tar.xz";
            sha256 = self.sha256;
          });

          meta = with pkgs.lib; {
            homepage = "http://www.lxqt.org";
            license = licenses.lgpl21;
            platforms = platforms.linux;
            maintainers = [ maintainers.ellis ];
          };
        } super;
    in self);

  # For compiling information, see:
  # - http://wiki.lxde.org/en/Build_LXDE-Qt_From_Source
  # - the lxde project on github

  # packages are listed here in the same order as they are
  # compiled by the build_all.sh script in the lxde-qt repository.

  # first the autotools packages
  lxmenu-data = callPackage ./data/lxmenu-data.nix { };

  # now the cmake packages

  libqtxdg = callPackage ./base/libqtxdg.nix { };
  liblxqt = callPackage ./base/liblxqt.nix { };
  liblxqt-mount = callPackage ./base/liblxqt-mount.nix { };
  libsysstat = callPackage ./base/libsysstat.nix { };

  lxqt-session = callPackage ./core/lxqt-session.nix { };
  lxqt-qtplugin = callPackage ./core/lxqt-qtplugin.nix { };
  lxqt-globalkeys = callPackage ./core/lxqt-globalkeys.nix { };
  lxqt-notificationd = callPackage ./core/lxqt-notificationd.nix { };
  lxqt-about = callPackage ./core/lxqt-about.nix { };
  lxqt-common = callPackage ./data/lxqt-common.nix { };
  lxqt-config = callPackage ./core/lxqt-config.nix { };

  lxqt-admin = callPackage ./core/lxqt-admin.nix { };

  lxqt-openssh-askpass = callPackage ./core/lxqt-openssh-askpass.nix { };
  lxqt-panel = callPackage ./core/lxqt-panel.nix { };
  lxqt-policykit = callPackage ./core/lxqt-policykit.nix { };
  lxqt-powermanagement = callPackage ./core/lxqt-powermanagement.nix { };
  lxqt-runner = callPackage ./core/lxqt-runner.nix { };
  pcmanfm-qt = callPackage ./core/pcmanfm-qt.nix { };
  lximage-qt = callPackage ./core/lximage-qt.nix { };

  compton-conf = callPackage ./core/compton-conf.nix { };
  obconf-qt = callPackage ./core/obconf-qt.nix { };

# TODO:
# - [x] remove -DUSE_QT_5=ON where it's not needed
# - [x] write a script to patch CMakeLists.txt for various paths
# - [x] need to fix Qt's translation path, so translations are stored in the correct place in /nix/store but read from /run/current-system/sw/
# - [ ] lxqt-common: figure out what to do with the xsession files
# - [ ] test whether `-DLIB_SUFFIX` can be removed from everywhere
# - [ ] install lxqt.desktop in `desktops` package somehow (see desktops/xfce.desktop)
# - [ ] install lxqt.desktop from lxqt-common/xsession to $out/share/xsessions (see xfce4-session/share/xsessions/xfce.desktop)
# - [ ] figure out how to make sure Qt sees the plugins from core/lxqt-qtplugin, and which directory should we install the plugins to?
#   - see http://qt-project.org/doc/qt-5/deployment-plugins.html
#   - see README in lxqt-qtplugin repository
# - [ ] lxqt-common: I suppress the installation of .desktop session files for kdm/xdm; what should be done?
# - [ ] add maintainers metadata
};

in lxqtSelf
