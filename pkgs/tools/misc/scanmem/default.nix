{ stdenv, lib, autoconf, automake, intltool, libtool, fetchFromGitHub, readline
, withGui ? true, python, gtk3, gobject-introspection, pygobject3, wrapPython, wrapGAppsHook }:

stdenv.mkDerivation rec {
  version = "0.17";
  pname = "scanmem";

  src = fetchFromGitHub {
    owner  = "scanmem";
    repo   = "scanmem";
    rev    = "v${version}";
    sha256 = "17p8sh0rj8yqz36ria5bp48c8523zzw3y9g8sbm2jwq7sc27i7s9";
  };

  nativeBuildInputs = [ autoconf automake intltool libtool ] ++ lib.optionals withGui [ wrapPython wrapGAppsHook ];
  pythonPath = lib.optionals withGui [ pygobject3 ];
  buildInputs = [ readline ] ++ lib.optionals withGui [ gtk3 gobject-introspection python ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = lib.optional withGui "--enable-gui";

  dontWrapGApps = true;

  postFixup = ''
    wrapGApp "$out/share/gameconqueror/GameConqueror.py"
    wrapPythonProgramsIn "$out/share/gameconqueror" "$out $pythonPath"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/scanmem/scanmem";
    description = "Memory scanner for finding and poking addresses in executing processes";
    maintainers = [ maintainers.chattered ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };

}
