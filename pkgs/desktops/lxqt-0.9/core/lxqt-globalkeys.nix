{ mkLxqt
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-globalkeys";
  version = "0.9.0";
  sha256 = "04lzbncbx91n8m7z1jki73bwhw76mmk86dbxza5g3hlcbq92waa5";

  nativeBuildInputs = [ cmake qt.tools ];

  buildInputs = [ liblxqt ];

  meta.description = "Daemon and library for global keyboard shortcuts registration";
}
