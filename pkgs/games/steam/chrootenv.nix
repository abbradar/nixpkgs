{ lib, buildFHSUserEnv, config }:

buildFHSUserEnv {
  name = "steam";

  targetPkgs = pkgs:
    [ pkgs.steam-original
      # Errors in output without those
      pkgs.pciutils
      pkgs.python2
    ]
    ++ lib.optional (config.steam.java or false) pkgs.jdk
    ++ lib.optional (config.steam.primus or false) pkgs.primus
    ;

  multiPkgs = pkgs:
    [ # These are required by steam with proper errors
      pkgs.xlibs.libXcomposite
      pkgs.xlibs.libXtst
      pkgs.xlibs.libXrandr
      pkgs.xlibs.libXext
      pkgs.xlibs.libX11
      pkgs.xlibs.libXfixes

      pkgs.glib
      pkgs.gtk2
      pkgs.bzip2
      pkgs.zlib
      pkgs.libpulseaudio
      pkgs.gdk_pixbuf

      # Without these it silently fails
      pkgs.xlibs.libXinerama
      pkgs.xlibs.libXdamage
      pkgs.xlibs.libXcursor
      pkgs.xlibs.libXrender
      pkgs.xlibs.libXi
      pkgs.xlibs.libSM
      pkgs.xlibs.libICE
      pkgs.gnome2.GConf
      pkgs.freetype
      pkgs.openalSoft
      pkgs.curl
      pkgs.nspr
      pkgs.nss
      pkgs.fontconfig
      pkgs.cairo
      pkgs.pango
      pkgs.alsaLib
      pkgs.expat
      pkgs.dbus
      pkgs.cups
      pkgs.libcap
      pkgs.SDL2
      pkgs.libusb1
      pkgs.dbus_glib
      pkgs.ffmpeg
      # Only libraries are needed from those two
      pkgs.udev182
      pkgs.networkmanager098

      # Games requirements
      pkgs.xlibs.libXmu
      pkgs.xlibs.libxcb
      pkgs.xlibs.libpciaccess
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.mesa_glu
      pkgs.libuuid
      pkgs.libogg
      pkgs.libvorbis
      pkgs.SDL
      pkgs.SDL2_image
      pkgs.glew110
      pkgs.openssl
      pkgs.libidn
    ];

  extraBuildCommandsMulti = ''
    cd usr/lib
    ln -sf ../lib64/steam steam

    # FIXME: maybe we should replace this with proper libcurl-gnutls
    ln -s libcurl.so.4 libcurl-gnutls.so.4
  '';

  profile = ''
    export STEAM_RUNTIME=0
  '';

  runScript = "steam";
}
