{stdenv, fetchurl, pkgconfig, system-tools-backends, glib, dbus_glib }:

let majorVersion = "3.0";
in stdenv.mkDerivation rec {
  name = "liboobs-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/liboobs/${majorVersion}/${name}.tar.gz";
    sha256 = "1fhg1fag08c1ckrhyrm4gxpb2lz5ll7nl5rl19vxgnh0rhr2d5nb";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib dbus_glib system-tools-backends ];

  meta = with stdenv.lib; {
    description = "GObject based interface to system-tools-backends - shared library";
    homepage = http://developer.gnome.org/liboobs/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
