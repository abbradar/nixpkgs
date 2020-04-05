{ stdenv, buildPythonPackage, fetchPypi, typing-inspect, marshmallow, marshmallow-enum, stringcase, isPy27 }:

buildPythonPackage rec {
  pname = "dataclasses-json";
  version = "0.4.2";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Zaya4vfsFS7gG/QsjAJHNtTNb2+3YVAt7JK9VTkx49k=";
  };

  propagatedBuildInputs = [ typing-inspect marshmallow marshmallow-enum stringcase ];

  meta = with stdenv.lib; {
    description = "Easily serialize dataclasses to and from JSON";
    homepage = "https://github.com/lidatong/dataclasses-json";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
