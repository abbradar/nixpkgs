{ mkLxqt
, pkgconfig
, cmake
, qt
, kguiaddons
# lxqt dependencies
, liblxqt
, liblxqt-mount
, lxqt-globalkeys
, libsysstat
# optional lxqt dependencies
, menu-cache

# additional optional dependencies
, icu
, alsaLib
, libpulseaudio
, lm_sensors
, libstatgrab
}:

mkLxqt {
  basename = "lxqt-panel";
  version = "0.9.0";
  sha256 = "1wbb1x2z4cx04i3dh49f6hs013ygdxp9757hg6n0axnynzqw5cln";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    kguiaddons
    liblxqt liblxqt-mount lxqt-globalkeys libsysstat
    menu-cache
    icu alsaLib libpulseaudio lm_sensors libstatgrab
  ];

  meta.description = "Desktop panel";
}
