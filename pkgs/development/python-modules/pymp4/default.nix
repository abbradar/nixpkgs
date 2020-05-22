{ stdenv, python, buildPythonPackage, fetchFromGitHub, fetchPypi, six, pytest, arrow }:

let construct =
  buildPythonPackage rec {
    pname   = "construct";
    version = "2.8.8";

    src = fetchFromGitHub {
      owner  = pname;
      repo   = pname;
      rev    = "v${version}";
      sha256 = "038yxsxph02pxw5yj2x76jjb1vv4d13q8f7p1cd0280549k583nc";
    };

    propagatedBuildInputs = [ six ];

    checkInputs = [ pytest arrow ];

    # TODO: figure out missing dependencies
    doCheck = false;
    checkPhase = ''
      py.test -k 'not test_numpy and not test_gallery' tests
    '';

    meta = with stdenv.lib; {
      description = "Powerful declarative parser (and builder) for binary data";
      homepage = https://construct.readthedocs.org/;
      license = licenses.mit;
      maintainers = with maintainers; [ bjornfor ];
    };
  };

in buildPythonPackage rec {
  pname = "pymp4";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mklf9r4707k50z7my4j44hv14bdw5wm7x34vk9qrqng7042wgaa";
  };

  propagatedBuildInputs = [ construct ];

  # Tests don't work on Python 3
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python MP4 Parser and toolkit";
    homepage = https://github.com/beardypig/pymp4;
    license = licenses.asl20;
    maintainers = with maintainers; [ abbradar ];
  };
}
