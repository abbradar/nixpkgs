{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
, ipython
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "Represent";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12pprv1j5liadlcgj14c1ihcp7h0rp1gx6x44451bqp9nb4gwg99";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ipython sqlalchemy ];

  meta = with lib; {
    description = "Create __repr__ automatically or declaratively.";
    homepage = https://github.com/RazerM/represent;
    license = licenses.mit;
    maintainers = [ maintainers.abbradar ];
  };
}
