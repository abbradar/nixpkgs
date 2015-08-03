{ mkLxqt
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-common";
  version = "0.9.1";
  sha256 = "0kbkwmrdjhfbq60wf2yfbsjmci8xlw13ilxxa7yxq68n1aqjqmvf";

  nativeBuildInputs = [
    cmake
    qt.tools
  ];

  buildInputs = [
    liblxqt
  ];

  patches = ./lxqt-common.patch;

  meta.description = "Common data file required for running an lxde-qt session";
}
