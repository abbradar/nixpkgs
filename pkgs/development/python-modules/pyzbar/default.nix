{ lib, buildPythonPackage, fetchFromGitHub, pillow, numpy, zbar }:

buildPythonPackage rec {
  pname = "pyzbar";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "NaturalHistoryMuseum";
    repo = "pyzbar";
    rev = "v${version}";
    sha256 = "sha256-VEMfGCqXErNI4RJKKc3Mly5KytciahD//zRtcctzFLs=";
  };

  propagatedBuildInputs = [ pillow numpy ];

  postPatch = ''
    sed -i "s,find_library('zbar'),'${zbar.lib}/lib/libzbar.so',g" pyzbar/zbar_library.py
  '';

  doCheck = false;

  meta = with lib; {
    description = "Read one-dimensional barcodes and QR codes from Python 2 and 3.";
    homepage = "https://github.com/NaturalHistoryMuseum/pyzbar/";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
