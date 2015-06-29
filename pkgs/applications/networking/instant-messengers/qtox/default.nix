{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, qt5, openalSoft
, libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo, pango, atk
, qrencode, ffmpeg, filter_audio }:

stdenv.mkDerivation rec {
  name = "qtox-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "tux3";
    repo = "qTox";
    rev = "v${version}";
    sha256 = "1i9q3s6fm6w7njzrvmhy2dbdj0x4skpx1c7m6r1hjlhmii8ywbsn";
  };

  NIX_CFLAGS_COMPILE = [ "-I${glib}/lib/glib-2.0/include"
                         "-I${glib}/include/glib-2.0"
                         "-I${gdk_pixbuf}/include/gdk-pixbuf-2.0"
                         "-I${gtk2}/include/gtk-2.0"
                         "-I${gtk2}/lib/gtk-2.0/include"
                         "-I${cairo}/include/cairo"
                         "-I${pango}/include/pango-1.0"
                         "-I${atk}/include/atk-1.0"
                       ];

  buildInputs =
    [
      libtoxcore openalSoft filter_audio qt5.base
      glib libXScrnSaver gdk_pixbuf gtk2 cairo
      libsodium qrencode ffmpeg
    ];
  nativeBuildInputs = [ qt5.tools ];

  postPatch = ''
    #sed -i "s,/usr/,/this-does-not-exist/,g" qtox.pro
  '';

  configurePhase = "qmake";

  installPhase = ''
    mkdir -p $out/bin
    cp qtox $out/bin
  '';

  meta = with stdenv.lib; {
    description = "QT Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds ];
    platforms = platforms.all;
  };
}
