{ mkLxqt
, pkgconfig
, cmake
, qt
, libfm
, pcmanfm-qt
, libexif
}:

mkLxqt {
  basename = "lximage-qt";
  version = "0.4.0";
  lxqtBundled = false;
  sha256 = "0c4psl015j3vir0jh1xyg6c1kilx6hlkxjs2mm52brj616dwkaqi";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    libfm pcmanfm-qt
    qt.base qt.x11extras
    libexif
  ];

  meta.description = "Image viewer";
}
