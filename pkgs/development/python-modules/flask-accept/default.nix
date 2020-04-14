{ stdenv, fetchPypi, buildPythonPackage, flask }:

buildPythonPackage rec {
  pname = "flask_accept";
  version = "0.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w2ciwipiwmg6x999w9cipd95njf81kd23yfmggdmagi0pcgfj5y";
  };

  doCheck = false; # Tests are not included in PyPi distribution.
  propagatedBuildInputs = [ flask ];

  meta = with stdenv.lib; {
    description = "Custom Accept header routing support for Flask";
    homepage = https://github.com/di/flask-accept;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ abbradar ];
  };
}
