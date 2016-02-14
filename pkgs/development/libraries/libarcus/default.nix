{ stdenv, fetchFromGitHub, cmake, protobuf, python }:

assert python.isPy3 or false;

stdenv.mkDerivation rec {
  name = "libArcus-${version}";
  version = "15.06.03";
  
  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libArcus";
    rev = version;
    sha256 = "0bn0jvz9qhg2bi87k7fcy3hvgzvv5sp1z0y9bn0kmlw1vk5czn82";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python ];
  propagatedBuildInputs = [ protobuf ];
  outputs = [ "out" "python" ];

  postInstall = ''
    mkdir -p $python/${python.sitePackages}
    mv $out/lib/python*/dist-packages/* $python/${python.sitePackages}
    rm -rf $out/lib/python*
  '';

  meta = with stdenv.lib; {
    description = "Communication library between internal components for Ultimaker software";
    homepage = https://github.com/Ultimaker/libArcus;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ abbradar ];
  };
}
