{ stdenv, lib, fetchurl, flac, gtk, libvorbis, libvpx, makeDesktopItem, mesa, nasm
, pkgconfig, SDL2, SDL2_mixer }:

let
  date = "20160313";
  rev = "5669";

  year = lib.substring 0 4 date;

in stdenv.mkDerivation rec {
  name = "eduke32-${version}";
  version = "${date}-${rev}";

  src = fetchurl {
    urls = [
      "http://dukeworld.duke4.net/eduke32/synthesis/${version}/eduke32_src_${version}.tar.xz"
      "http://dukeworld.duke4.net/eduke32/synthesis/old/${year}/${version}/eduke32_src_${version}.tar.xz"
    ];
    sha256 = "0xhk5cr1ww5ar0mk9pfvyx0c89qv8xj1zw41plq758mz9vw3ajrm";
  };

  buildInputs = [ flac gtk libvorbis libvpx mesa SDL2 SDL2_mixer ]
    ++ lib.optional (stdenv.system == "i686-linux") nasm;
  nativeBuildInputs = [ pkgconfig ];

  postPatch = ''
    substituteInPlace build/src/glbuild.c \
      --replace libGL.so	${mesa}/lib/libGL.so \
      --replace libGLU.so	${mesa}/lib/libGLU.so
  '';

  NIX_CFLAGS_COMPILE = [ "-I${SDL2}/include/SDL" ];
  NIX_LDFLAGS = [ "-L${SDL2}/lib" ];

  makeFlags = [
    "LINKED_GTK=1"
    "SDLCONFIG=${SDL2}/bin/sdl2-config"
    "VC_REV=${rev}"
  ];

  desktopItem = makeDesktopItem {
    name = "eduke32";
    exec = "eduke32-wrapper";
    comment = "Duke Nukem 3D port";
    desktopName = "Enhanced Duke Nukem 3D";
    genericName = "Duke Nukem 3D port";
    categories = "Application;Game;";
  };

  installPhase = ''
    # Make wrapper script
    cat > eduke32-wrapper <<EOF
    #!/bin/sh

    if [ "\$EDUKE32_DATA_DIR" = "" ]; then
        EDUKE32_DATA_DIR=/var/lib/games/eduke32
    fi
    if [ "\$EDUKE32_GRP_FILE" = "" ]; then
        EDUKE32_GRP_FILE=\$EDUKE32_DATA_DIR/DUKE3D.GRP
    fi

    cd \$EDUKE32_DATA_DIR
    exec $out/bin/eduke32 -g \$EDUKE32_GRP_FILE
    EOF

    # Install binaries
    mkdir -p $out/bin
    install -Dm755 eduke32{,-wrapper} mapster32 $out/bin

    # Install desktop item
    cp -rv ${desktopItem}/share $out
  '';

  meta = with stdenv.lib; {
    description = "Enhanched port of Duke Nukem 3D for various platforms";
    license = licenses.gpl2Plus;
    homepage = http://eduke32.com;
    maintainers = with maintainers; [ nckx sander ];
    platforms = platforms.linux;
  };
}
