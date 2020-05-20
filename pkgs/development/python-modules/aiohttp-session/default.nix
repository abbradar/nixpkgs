{ lib, fetchPypi, buildPythonPackage, pythonOlder, aiohttp, attrs }:

buildPythonPackage rec {
  pname = "aiohttp-session";
  version = "2.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x7b5bl36d045l320v0g5rm0c000zdy626cpl1y0xqw4id31754m";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Checks needs internet access
  doCheck = false;

  meta = {
    description = "Web sessions for aiohttp.web";
    license = lib.licenses.asl20;
    homepage = "https://github.com/aio-libs/aiohttp-session";
  };
}
