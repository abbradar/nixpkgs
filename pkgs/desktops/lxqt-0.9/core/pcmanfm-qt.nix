{ mkLxqt
, pkgconfig
, cmake
, qt
, libfm
, menu-cache
}:

mkLxqt {
  basename = "pcmanfm-qt";
  version = "0.9.0";
  sha256 = "1pz245jc8ck7p7zrlfdkjyl8wv6nmsr5l98ifdpfxycjq2hg1w1d";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    qt.base qt.x11extras
    libfm
    menu-cache
  ];

  meta.description = "File manager";
}
