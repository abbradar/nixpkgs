{ stdenv, fetchFromGitHub
, libpng, libjpeg, libogg, libvorbis, freetype, smpeg2
, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer
, xmlto, perl, docbook_xsl }:

stdenv.mkDerivation {
  name = "ponscripter-wh-unstable-2019-10-01";

  src = fetchFromGitHub {
    owner = "chronotrig";
    repo = "ponscripter-fork-wh";
    rev = "c7d352bf4deda288ef62dbca40492e49a707b369";
    sha256 = "0lxiy490vsyw18v248xgdiwvyim87xrxca119ygiq5qzgc594qa3";
  };

  # We use bundled SDL2_mixer with old smpeg support.
  # This one is used only for its propagated dependencies.
  buildInputs = [ libpng libjpeg libogg libvorbis freetype smpeg2
                  SDL2 SDL2_image SDL2_ttf SDL2_mixer
                ];

  nativeBuildInputs = [ xmlto perl docbook_xsl ];

  postPatch = ''
    # Our GCC is actually newer than 4 and this confuses configure.
    sed -i 's,USE_CPU_GFX=false,USE_CPU_GFX=true,g' configure
  '';

  # Fails to link without this.
  NIX_LDFLAGS = [ "-lFLAC" "-lfluidsynth" ];

  preBuild = ''
    patchShebangs util
  '';

  meta = with stdenv.lib; {
    description = "Fork of the Ponscripter visual novel engine to take advantage of SDL2 and improve Steam integration";
    homepage = "https://github.com/chronotrig/ponscripter-fork-wh/tree/wh-dev";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
  };
}
