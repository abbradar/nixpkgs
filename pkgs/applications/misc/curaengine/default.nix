{ stdenv, fetchFromGitHub, cmake, libarcus }:

stdenv.mkDerivation rec {
  name = "curaengine-${version}";
  version = "15.06.03";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    rev = version;
    sha256 = "1jr7gri3rmk3xdcqhs7nwhh8r0vynjbcvjkc9pnhfd1qwidkpy4c";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libarcus ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Engine for processing 3D models into 3D printing instructions";
    homepage = https://github.com/Ultimaker/CuraEngine;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
