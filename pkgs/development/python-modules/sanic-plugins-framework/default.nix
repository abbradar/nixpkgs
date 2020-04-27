{ lib, buildPythonPackage, fetchPypi, sanic }:

buildPythonPackage rec {
  pname = "Sanic-Plugins-Framework";
  version = "0.9.2";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0qxipcpvpd09w4wki6i58plcgyxjabcp9hg5krj71q7r73r3jd76";
  };
  
  propagatedBuildInputs = [ sanic ];

  # Tests are not bundled with PyPi distribution.
  doCheck = false;

  meta = with lib; {
    description = "Doing all of the boilerplate to create a Sanic Plugin, so you don't have to.";
    homepage = "https://github.com/ashleysommer/sanicpluginsframework";
    license = licenses.mit;
    maintainers = [ maintainers.abbradar ];
  };
}
