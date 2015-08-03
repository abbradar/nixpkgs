{ mkLxqt
, pkgconfig
, cmake
, qt
, liblxqt
, lxqt-globalkeys
}:

mkLxqt {
  basename = "lxqt-runner";
  version = "0.9.0";
  sha256 = "16j3cv08l5sdlidx8p6zi1vyyfbrcxx66hfaj9wf3adjmj2lv7bx";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    qt.script
    liblxqt lxqt-globalkeys
  ];

  meta.description = "Launch applications quickly by typing commands";
}
