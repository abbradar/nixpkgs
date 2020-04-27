{ lib
, buildPythonPackage
, fetchPypi
, sqlalchemy
, outcome
, represent
, pytest
}:

buildPythonPackage rec {
  pname = "sqlalchemy_aio";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dsmlnicpdx3jmk8fivy5i6iap5rnx7gvd5ysvv9kx2943094g9z";
  };

  propagatedBuildInputs = [
    sqlalchemy
    outcome
    represent
  ];

  checkInputs = [
    pytest
  ];

  doCheck = false;

  meta = with lib; {
    description = "Asyncio strategy for SQLAlchemy.";
    homepage = https://github.com/RazerM/sqlalchemy_aio;
    license = licenses.mit;
    maintainers = [ maintainers.abbradar ];
  };
}
