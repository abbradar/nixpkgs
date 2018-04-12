{ lib, stdenv, fetchurl, makeWrapper, pkgconfig, texinfo
, cairo, gd, libcerf, pango, readline, zlib
, withTeXLive ? false, texlive
, withLua ? false, lua
, emacs ? null
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, aquaterm ? false
, withWxGTK ? false, wxGTK_3 ? null
, fontconfig ? null
, gnused ? null
, coreutils ? null
, withQt ? false, qttools, qtbase, qtsvg
}:

assert libX11 != null -> (fontconfig != null && gnused != null && coreutils != null);
let
  withX = libX11 != null && !aquaterm && !stdenv.isDarwin;
in
stdenv.mkDerivation rec {
  name = "gnuplot-${version}";
  version = "5.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${name}.tar.gz";
    sha256 = "0977vgjszjpqhz2jahq07zmcmi0k9d6v7wq70ph2klfrb29qrdgy";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig texinfo ] ++ lib.optional withQt qttools;

  buildInputs =
    [ cairo gd libcerf pango readline zlib ]
    ++ lib.optional withTeXLive (texlive.combine { inherit (texlive) scheme-small; })
    ++ lib.optional withLua lua
    ++ lib.optionals withX [ libX11 libXpm libXt libXaw ]
    ++ lib.optionals withQt [ qtbase qtsvg ]
    ++ lib.optional withWxGTK wxGTK_3;

  postPatch = ''
    # lrelease is in qttools, not in qtbase.
    sed -i configure -e 's|''${QT5LOC}/lrelease|lrelease|'
  '';

  configureFlags = [
    (if withX then "--with-x" else "--without-x")
    (if withQt then "--with-qt=qt5" else "--without-qt")
    (if aquaterm then "--with-aquaterm" else "--without-aquaterm")
  ];

  postInstall = lib.optionalString withX ''
    wrapProgram $out/bin/gnuplot \
       --prefix PATH : '${gnused}/bin' \
       --prefix PATH : '${coreutils}/bin' \
       --prefix PATH : '${fontconfig.bin}/bin' \
       --run '. ${./set-gdfontpath-from-fontconfig.sh}'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.gnuplot.info/;
    description = "A portable command-line driven graphing utility for many platforms";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ lovek323 ];
  };
}
