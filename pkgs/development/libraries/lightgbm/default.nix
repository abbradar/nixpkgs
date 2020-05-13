{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "lightgbm";
  version = "unstable-2020-05-13";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "LightGBM";
    rev = "f155379c1fe4e53d5d1c7fd195987a8d3aec4331";
    sha256 = "1clnkc5r8vrk3hp108z021mk7qhvdf5gw9dh0hn5rdrnpkksswak";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://lightgbm.readthedocs.io/en/latest/index.html";
    description = "a gradient boosting framework that uses tree based learning algorithms";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
