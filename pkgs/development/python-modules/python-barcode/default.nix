{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm }:

buildPythonPackage rec {
  pname = "python-barcode";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "034j70ww3imravya27a13wbcxnxy8z41rqkqrpvyhwx30cy9ngsz";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = with stdenv.lib; {
    description = "Create standard barcodes with Python.";
    homepage = https://github.com/WhyNotHugo/python-barcode;
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
