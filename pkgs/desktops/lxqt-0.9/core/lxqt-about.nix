{ mkLxqt
, pkgconfig
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-about";
  version = "0.9.0";
  sha256 = "0xxz93y4bk00bhdj3yn3y8ybp2xay89dl26pxdydkjwap9gfnrb9";

  nativeBuildInputs = [
    #pkgconfig
    cmake
    #qt.tools
  ];
  
  buildInputs = [
    liblxqt
  ];

  meta.description = "About dialog for lxde-qt";
}
