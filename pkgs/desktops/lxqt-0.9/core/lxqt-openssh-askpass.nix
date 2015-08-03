{ mkLxqt
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-openssh-askpass";
  version = "0.9.0";
  sha256 = "0ax7m81y9p0akqlfma3ghfl0k7ads26nq75k957dbbc3hmn69jcm";

  nativeBuildInputs = [
    cmake
    qt.tools
  ];

  buildInputs = [
    liblxqt
  ];

  meta.description = "Tool used with openssh to prompt the user for password";
}
