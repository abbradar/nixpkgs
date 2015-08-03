{stdenv, fetchurl, pkgconfig, intltool, dbus, glib, dbus_glib, polkit }:

let majorVersion = "2.10";
in stdenv.mkDerivation rec {
  name = "system-tools-backends-${majorVersion}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/system-tools-backends/${majorVersion}/${name}.tar.gz";
    sha256 = "1anfppkff36avxn9s80yq8bbcan61snn5s5xnpi4lhj0wnahgckw";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ glib dbus dbus_glib polkit ];

  meta = with stdenv.lib; {
    description = "A wrapping library to the System Tools Backends";
    homepage = http://system-tools-backends.freedesktop.org/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
