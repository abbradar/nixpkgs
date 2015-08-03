{ mkLxqt
, pkgconfig
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-powermanagement";
  version = "0.9.0";
  sha256 = "0sq0qfqaz9pf47g2m5szpq3dqwqcjz32kiwcars7lc3nk6ddw0j6";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    liblxqt
  ];

  meta.description = "Daemon use for power management and auto-suspend";
}
