{ mkLxqt, fetchFromGitHub
, pkgconfig
, cmake
, qt
, libconfig
, openbox
}:

mkLxqt rec {
  basename = "obconf-qt";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = basename;
    rev = version;
    sha256 = "1ywjfi2kkrwa840gwd75z3pmly3q28ilddq6mkkncbkb0av5byb8";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    qt.base qt.x11extras
    libconfig
    openbox
  ];

  cmakeFlags = [ "-DUSE_QT5=ON" ];

  meta.description = "X composite manager configuration (for Openbox)";
}
