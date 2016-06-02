{ lib, replaceDependency, krita, qtbase }:

replaceDependency {
  drv = krita;
  oldDependency = lib.getLib qtbase;
  newDependency = let
    qtbase_ = lib.overrideDerivation qtbase (attrs: {
      patches = attrs.patches ++ [ "${krita.src}/3rdparty/ext_qt/qt-no-motion-compression.diff" ];
    });
    in lib.getLib qtbase_;
}
