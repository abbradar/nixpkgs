{ stdenv, fetchFromGitHub, cmake, pkgconfig, makeWrapper
, boost, zlib, libpng, libjpeg, openssl, libwebp, catch2 }:

stdenv.mkDerivation {
  name = "arc_unpacker-unstable-2018-12-09";

  src = fetchFromGitHub {
    owner = "vn-tools";
    repo = "arc_unpacker";
    rev = "b9843a13e2b67a618020fc12918aa8d7697ddfd5";
    sha256 = "0wpl30569cip3im40p3n22s11x0172a3axnzwmax62aqlf8kdy14";
  };

  buildInputs = [ boost zlib libpng libjpeg openssl libwebp ];
  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  preConfigure = ''
    ln -s ${catch2}/include/catch2/catch.hpp tests/test_support/catch.h
  '';

  enableParallelBuilding = true;

  installPhase = ''
    install -Dm755 build/arc_unpacker $out/opt/arc_unpacker/arc_unpacker
    cp -r etc $out/opt/arc_unpacker
    mkdir $out/bin
    makeWrapper $out/opt/arc_unpacker/arc_unpacker $out/bin/arc_unpacker
  '';

  doCheck = true;
  checkPhase = ''
    cd ..
    build/run_tests
  '';

  meta = with stdenv.lib; {
    description = "CLI tool for extracting images and sounds from visual novels";
    homepage = "https://github.com/vn-tools/arc_unpacker";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
