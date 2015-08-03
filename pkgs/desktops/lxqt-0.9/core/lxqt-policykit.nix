{ mkLxqt
, pkgconfig
, cmake
, qt
, polkit_qt5
, liblxqt
}:

mkLxqt {
  basename = "lxqt-policykit";
  version = "0.9.0";
  sha256 = "0jgm5hf2lny1frlcmhp7gaiq7lg9xrxv89az80q46pq8b5l4pvbb";

  nativeBuildInputs = [
    pkgconfig
    cmake
    qt.tools
  ];

  buildInputs = [
    polkit_qt5
    liblxqt
  ];

  meta.description = "Policykit authentication agent";
}
