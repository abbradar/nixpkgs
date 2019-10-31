{ stdenv, meson, ninja, pkgconfig, glib, libcap }:

stdenv.mkDerivation {
  name = "chrootenv";
  src = ./.;

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ glib libcap ];

  meta = with stdenv.lib; {
    description = "Setup mount/user namespace for FHS emulation";
    license = licenses.mit;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
