{ stdenv, fetchFromGitHub, cmake }:

let
  version = "1.3";

in stdenv.mkDerivation {
  name = "postsrsd-${version}";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "1z89qh2bnypgb4i2vs0zdzzpqlf445jixwa1acd955hryww50npv";
  };

  cmakeFlags = [ "-DGENERATE_SRS_SECRET=OFF" ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/roehling/postsrsd";
    description = "Postfix Sender Rewriting Scheme daemon";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
