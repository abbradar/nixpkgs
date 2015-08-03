{ mkLxqt
, cmake
, qt
, kwindowsystem
, libqtxdg
}:

mkLxqt {
  basename = "liblxqt";
  version = "0.9.0";
  sha256 = "0ljdzqavvy82qwwwnhg2bgbshl2ns0k2lcswxlx1cfc8rcdr9w5l";

  nativeBuildInputs = [ cmake qt.tools ];

  patches = [ ./liblxqt.patch ];

  propagatedBuildInputs = [ qt.base qt.x11extras kwindowsystem libqtxdg ];

  postInstall = ''
    mkdir -p $out/nix-support
    cat <<EOF >$out/nix-support/setup-hook
    cmakeFlags="-DLXQT_ETC_XDG_DIR=\$out/etc/xdg \$cmakeFlags"
    EOF
  '';

  meta.description = "Common base library for most lxde-qt components";
}
