{ mkLxqt
, pkgconfig
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-session";
  version = "0.9.0";
  sha256 = "01hxand1gqbcaw14lh7z6w5zssgfaffcjncv752c2c7272wzyhy5";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    liblxqt
  ];

  meta.description = "Session manager";
}
