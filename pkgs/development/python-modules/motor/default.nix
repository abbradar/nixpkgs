{ lib
, buildPythonPackage
, fetchPypi
, pymongo
}:

buildPythonPackage rec {
  pname = "motor";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d09v1v3v6nf1k30zz22xf3vjvsqigxkdkaccip1crnihmwmhv3m";
  };

  propagatedBuildInputs = [
    pymongo
  ];

  # tests require mongodb running in background
  doCheck = false;

  meta = with lib; {
    description = "Non-blocking MongoDB driver for Tornado or asyncio";
    homepage = "https://github.com/mongodb/motor/";
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
