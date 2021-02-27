{ lib
, buildPythonPackage
, fetchPypi
, certifi
, Babel
, aiohttp
}:

buildPythonPackage rec {
  pname = "aiogram";
  version = "2.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hRzbWDuftUbRO7T4zQrgwBqso5jcwWh9EiNhhJCpEig=";
  };

  propagatedBuildInputs = [
    certifi
    Babel
    aiohttp
  ];

  doCheck = false;

  meta = with lib; {
    description = "Is a pretty simple and fully asynchronous framework for Telegram Bot API";
    homepage = "https://github.com/aiogram/aiogram";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ abbradar ];
  };
}
