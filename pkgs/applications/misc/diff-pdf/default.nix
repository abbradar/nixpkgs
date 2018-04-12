{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, cairo, poppler, wxGTK_3 ? null, wxmac ? null, darwin ? null }:

let
  wxInputs =
    if stdenv.isDarwin then
      [ wxmac darwin.apple_sdk.frameworks.Cocoa ]
    else
      [ wxGTK_3 ];
in
stdenv.mkDerivation rec {
  name = "diff-pdf-${version}";
  version = "2017-12-30";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "diff-pdf";
    rev = "c4d67226ec4c29b30a7399e75f80636ff8a6f9fc";
    sha256 = "1c3ig7ckrg37p5vzvgjnsfdzdad328wwsx0r31lbs1d8pkjkgq3m";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];
  buildInputs = [ cairo poppler ] ++ wxInputs;

  preConfigure = "./bootstrap";

  meta = with stdenv.lib; {
    homepage = http://vslavik.github.io/diff-pdf;
    description = "Simple tool for visually comparing two PDF files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
