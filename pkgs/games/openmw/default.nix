{ stdenv, fetchFromGitHub, qt4, openscenegraph, mygui, bullet, ffmpeg, boost, cmake, SDL2, unshield, openal, pkgconfig, libX11, unzip, ois, freetype, libuuid }:

stdenv.mkDerivation rec {
  version = "0.38.0";
  name = "openmw-${version}";

  src = fetchFromGitHub {
    owner = "OpenMW";
    repo = "openmw";
    rev = name;
    sha256 = "1ssz1pa59a34v5vxiccqyvij5s38kl662p7xbc59y90y668f78y6";
  };

  buildInputs = [ cmake boost ffmpeg qt4 bullet mygui openscenegraph SDL2 unshield openal pkgconfig ];

  meta = with stdenv.lib; {
    description = "An unofficial open source engine reimplementation of the game Morrowind";
    homepage = "http://openmw.org";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
