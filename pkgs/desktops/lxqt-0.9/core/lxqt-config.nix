{ mkLxqt
, pkgconfig
, cmake
, libpthreadstubs
, libXdmcp
, libxcb
, libXcursor
, qt
, kwindowsystem
, liblxqt
, libqtxdg
}:

mkLxqt {
  basename = "lxqt-config";
  version = "0.9.0";
  sha256 = "04xrhhzvp7xcs135n2dxny5714iv702cw1jq5k3dkibahhhhsswx";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    libpthreadstubs libXdmcp libxcb libXcursor
    liblxqt libxcb
  ];

  patches = [ ./lxqt-config.patch ];

  meta.description = "System configuration (control center)";
}
