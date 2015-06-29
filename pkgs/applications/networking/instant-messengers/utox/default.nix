{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, dbus, libvpx, libX11, openalSoft, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, filter_audio }:

stdenv.mkDerivation rec {
  name = "utox-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "notsecure";
    repo = "uTox";
    rev = "v${version}";
    sha256 = "1cwz4fbqhazybdjcwzwcws6zn996mgg26v9b8mbdls571sjbbqfl";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ dbus libtoxcore fontconfig freetype openalSoft libv4l
                  libX11 libXext libXrender filter_audio ];

  #doCheck = false;
  
  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iElectric jgeerds ];
    platforms = platforms.all;
  };
}
