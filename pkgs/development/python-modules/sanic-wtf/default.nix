{ lib, buildPythonPackage, fetchPypi, pytest, sanic, wtforms }:

buildPythonPackage rec {
  pname = "Sanic-WTF";
  version = "0.5.0";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0kawszpwcv4bf1adzrgzfsg969y8afw1qsnfgn0vi4p4ic68h47c";
  };
  
  propagatedBuildInputs = [ sanic wtforms ];

  # Tests are broken.
  doCheck = false;
  
  meta = with lib; {
    description = "Sanic meets WTForms";
    homepage = "https://sanic-wtf.readthedocs.io/en/latest/";
    license = licenses.bsd3;
    maintainers = [ maintainers.abbradar ];
  };
}
