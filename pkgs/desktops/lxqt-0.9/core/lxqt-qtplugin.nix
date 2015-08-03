{ mkLxqt
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-qtplugin";
  version = "0.9.0";
  sha256 = "1ia3calcl6m8qixvdz9yaadagckr3d23zcl9vib46yygbkaibivv";

  nativeBuildInputs = [
    cmake
    qt.tools
  ];

  buildInputs = [
    liblxqt
  ];

  patches = ./lxqt-qtplugin.patch;
  
  cmakeFlags = [ "-DQT_PLUGINS_DIR=lib/qt5/plugins" ];

  meta.description = "LxQt platform integration plugin for Qt5 (let all Qt programs apply LxQt settings)";
}
