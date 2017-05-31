# This module defines a standard configuration for NixOS global environment.

# Most of the stuff here should probably be moved elsewhere sometime.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.environment;

in

{

  config = {

    environment.variables =
      { NIXPKGS_CONFIG = "/etc/nix/nixpkgs-config.nix";
        PAGER = mkDefault "less -R";
        EDITOR = mkDefault "nano";
        XCURSOR_PATH = [ "$HOME/.icons" ];
        GTK_DATA_PREFIX = "/run/current-system/sw";
      };

    environment.profiles =
      [ "$HOME/.nix-profile"
        "/nix/var/nix/profiles/default"
        "/run/current-system/${pkgs.stdenv.system}-lib"
      ] ++ optional config.libraries.support32Bit "/run/current-system/${pkgs.pkgsi686Linux.stdenv.system}-lib" ++
      [ "/run/current-system/sw"
      ];

    # TODO: move most of these elsewhere
    environment.profileRelativeEnvVars =
      { PATH = [ "/bin" ];
        INFOPATH = [ "/info" "/share/info" ];
        PKG_CONFIG_PATH = [ "/lib/pkgconfig" ];
        TERMINFO_DIRS = [ "/share/terminfo" ];
        PERL5LIB = [ "/lib/perl5/site_perl" ];
        KDEDIRS = [ "" ];
        XDG_CONFIG_DIRS = [ "/etc/xdg" ];
        XDG_DATA_DIRS = [ "/share" ];
        XCURSOR_PATH = [ "/share/icons" ];

        LIBEXEC_PATH = [ "/lib/libexec" ];
        STRIGI_PLUGIN_PATH = [ "/lib/strigi" ];
        QT_PLUGIN_PATH = [ "/lib/qt4/plugins" "/lib/kde4/plugins" "/lib/qt5/plugins" ];
        QTWEBKIT_PLUGIN_PATH = [ "/lib/mozilla/plugins" ];
        GTK_PATH = [ "/lib/gtk-2.0" "/lib/gtk-3.0" ];
        MOZ_PLUGIN_PATH = [ "/lib/mozilla/plugins" ];
        GIO_EXTRA_MODULES = [ "/lib/gio/modules" ];
      };

    environment.extraInit =
      ''
         # reset TERM with new TERMINFO available (if any)
         export TERM=$TERM

         unset ASPELL_CONF
         for i in ${concatStringsSep " " (reverseList cfg.profiles)} ; do
           if [ -d "$i/lib/aspell" ]; then
             export ASPELL_CONF="dict-dir $i/lib/aspell"
           fi
         done

         export NIX_USER_PROFILE_DIR="/nix/var/nix/profiles/per-user/$USER"
         export NIX_PROFILES="${concatStringsSep " " (reverseList cfg.profiles)}"
      '';

  };

}
