{ mkLxqt
, cmake
, qt
, liblxqt
}:

mkLxqt {
  basename = "lxqt-notificationd";
  version = "0.9.0";
  sha256 = "092blya5bj94n7ji448dx4b9gmxmbn97dvfszp7x9ncy66380gzk";

  buildInputs = [ cmake qt.tools ];

  nativeBuildInputs = [ liblxqt ];

  meta.description = "Notification daemon and library";
}
