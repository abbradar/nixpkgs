{ mkLxqt, fetchgit
, pkgconfig
, cmake
, qt
, libconfig
}:

mkLxqt {
  basename = "compton-conf";
  version = "2015-06-26";

  src = fetchgit {
    url = "https://github.com/lxde/compton-conf";
    rev = "8ae8fbb95e2958adeaac681077a2751a1a776a07";
    sha256 = "04a9aa914befa9335b7d6c8a264ac2fa87cc902327c71fb253e17b16348aa674";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    qt.base
    libconfig
  ];

  meta.description = "X composite manager configuration (for compton)";
}
