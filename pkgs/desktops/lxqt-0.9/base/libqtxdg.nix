{ mkLxqt, fetchurl
, cmake
, file # libmagic.so
, qt
, pkgconfig
}:

mkLxqt rec {
  basename = "libqtxdg";
  version = "1.2.0";
  lxqtBundled = false;
  sha256 = "1ncqs0lcll5nx69hxfg33m3jfkryjqrjhr2kdci0b8pyaqdv1jc8";

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ qt.base file ];

  meta.description = "Library providing freedesktop.org specs implementations for Qt";
}
