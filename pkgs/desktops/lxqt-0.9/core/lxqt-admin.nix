{ mkLxqt
, pkgconfig
, cmake
, qt
, liblxqt
, liboobs
}:

mkLxqt {
  basename = "lxqt-admin";
  version = "0.9.0";
  sha256 = "0ia3mn6k866j621ifl6byjbyhbr1mdi4djvpwg0v05a61rqzni9q";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    liblxqt
    liboobs
  ];

  meta.description = "About dialog for lxde-qt";
}
