{ mkLxqt
, cmake
, qt
}:

mkLxqt {
  basename = "libsysstat";
  version = "0.3.0";
  lxqtBundled = false;
  sha256 = "061704pzhvbbzzrqbj5qpx0ayb26d8snnm83gjq7lm1f3jn0ar5b";

  nativeBuildInputs = [ cmake qt.tools ];

  buildInputs = [ qt.base ];

  meta.description = "Library used to query system statistics (net status, system resource usage, ...etc)";
}
