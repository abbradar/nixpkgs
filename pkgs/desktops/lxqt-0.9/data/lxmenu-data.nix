{ mkLxqt, fetchurl
, autoreconfHook
, glib, intltool
}:

mkLxqt rec {
  basename = "lxmenu-data";
  version = "0.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/lxmenu-data%20%28desktop%20menu%29/lxmenu-data%20${version}/lxmenu-data-${version}.tar.xz";
    sha256 = "077v9cbvw72rv9xls9ck9g2jgcgf63mnv4m2y3dq1b2civ4gn0l8";
  };

  nativeBuildInputs = [ autoreconfHook intltool ];
  buildInputs = [ glib ];

  meta.description = "Data files for application menu";
}
