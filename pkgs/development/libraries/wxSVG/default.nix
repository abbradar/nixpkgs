{ stdenv, fetchurl
, pkgconfig, wxGTK_3
, ffmpeg, libexif
, cairo, pango }:

stdenv.mkDerivation rec {

  name = "wxSVG-${version}";
  srcName = "wxsvg-${version}";
  version = "1.5.13";

  src = fetchurl {
    url = "mirror://sourceforge/project/wxsvg/wxsvg/${version}/${srcName}.tar.bz2";
    sha256 = "029a1rayp4c480x8ayng13rcjk1j98ar0z6ggijrznkn8kgx8j2j";
  };

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ wxGTK_3 ffmpeg libexif ];

  buildInputs = [ cairo pango ];

  meta = with stdenv.lib; {
    description = "A SVG manipulation library built with wxWidgets";
    longDescription = ''
    wxSVG is C++ library to create, manipulate and render
    Scalable Vector Graphics (SVG) files with the wxWidgets toolkit.
    '';
    homepage = http://wxsvg.sourceforge.net/;
    license = with licenses; gpl2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
