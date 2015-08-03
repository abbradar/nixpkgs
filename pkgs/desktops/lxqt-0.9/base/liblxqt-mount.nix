{ mkLxqt
, cmake
, qt
}:

mkLxqt {
  basename = "liblxqt-mount";
  version = "0.9.0";
  sha256 = "0pdzdl8v12pvmg4g4sdr0n8hddcwfaahzi2vjzw1p0v7dbhxr7f8";

  nativeBuildInputs = [ cmake qt.tools ];

  buildInputs = [ qt.base ];

  meta.description = "Library used to manage removable devices";
}
