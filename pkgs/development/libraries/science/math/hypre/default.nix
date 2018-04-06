{ stdenv, fetchurl, cmake, openmpi, openblas, gfortran }:

stdenv.mkDerivation rec {
  name = "hypre-${version}";
  version = "2.11.2";

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/${name}.tar.gz";
    sha256 = "17i6zgywcmgbmr7zxgc7shzqramg64a8kwswpdqkyn8ichic3di5";
  };

  sourceRoot = "${name}/src";

  buildInputs = [ openmpi openblas gfortran ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DHYPRE_SHARED=ON"
    "-DHYPRE_USING_HYPRE_BLAS=OFF"
    "-DHYPRE_USING_HYPRE_LAPACK=OFF"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out
    cp -r ../hypre/* $out
  '';

  meta = with stdenv.lib; {
    homepage = https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods;
    description = "Scalable Linear Solvers and Multigrid Methods";
    license = licenses.lgpl21;
    maintainers = with lib.maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
